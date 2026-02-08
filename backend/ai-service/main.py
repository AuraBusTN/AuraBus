from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import xgboost as xgb
import pandas as pd
import os
from apscheduler.schedulers.background import BackgroundScheduler
from trainer import retrain_model

MODEL_PATH = 'aurabus_brain_v1.json'


class StopInfo(BaseModel):
    stop_encoded: int
    hour: int
    day_of_week: int
    directionId: int


class TripRequest(BaseModel):
    route_encoded: int
    current_delay: int
    future_stops: List[StopInfo]


model = xgb.XGBRegressor()
is_model_loaded = False


def load_brain():
    global model, is_model_loaded
    if os.path.exists(MODEL_PATH):
        model.load_model(MODEL_PATH)
        is_model_loaded = True
        print('✅ Brain loaded! I\'m ready to predict.')
    else:
        print('⚠️ WARNING: Brain file not found. Predictions will not work.')


load_brain()

scheduler = BackgroundScheduler()

scheduler.add_job(
    lambda: retrain_model() and load_brain(),
    'cron',
    day_of_week='sun',
    hour=4,
    minute=0
)

scheduler.start()
print("⏰ Scheduler started: Training programmed every Sunday at 04:00")

retrain_model()

app = FastAPI()


@app.get('/')
def home():
    return {'status': 'OK', 'message': 'AuraBus AI is alive!'}


@app.post('/predict')
def predict(request: TripRequest):
    if not is_model_loaded:
        return {'error': 'Model not loaded. Cannot make predictions.'}

    predictions = []

    running_delay = request.current_delay

    for stop in request.future_stops:
        feature_names = ['route_encoded', 'stop_encoded',
                         'directionId', 'hour', 'day_of_week', 'delay']

        input_data = pd.DataFrame([[
            request.route_encoded,
            stop.stop_encoded,
            stop.directionId,
            stop.hour,
            stop.day_of_week,
            running_delay
        ]], columns=feature_names)

        prediction = model.predict(input_data, validate_features=False)

        predicted_delay = int(prediction[0])

        predictions.append({
            'stop_encoded': stop.stop_encoded,
            'predicted_delay': predicted_delay
        })

        running_delay = predicted_delay

    return {'predictions': predictions}
