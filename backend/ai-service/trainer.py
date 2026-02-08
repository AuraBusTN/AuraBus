import os
import pandas as pd
import xgboost as xgb
from pymongo import MongoClient

MONGO_URI = os.getenv('MONGO_URI')


def get_db_connection():
    uri = MONGO_URI
    if not uri:
        print("❌ ERROR: The MONGO_URI variable was not found in the .env!")
    client = MongoClient(uri)
    return client['test']


def retrain_model():
    print("🔌 Trying to connect to the Database...")
    try:
        db = get_db_connection()
        collection = db['tripmetrics']

        cursor = collection.find({}, {
            'timestamp': 1,
            'metadata.routeId': 1,
            'metadata.stopId': 1,
            'metadata.directionId': 1,
            'metadata.tripId': 1,
            'delay': 1,
            '_id': 0
        })

        data = list(cursor)

        if not data:
            print("⚠️ WARNING: No trip data found in the DB. Make sure the data collection service is active and sending data to the DB.")
            return False

        df = pd.json_normalize(data)

        df.rename(columns={
            'metadata.routeId': 'route_encoded',
            'metadata.stopId': 'stop_encoded',
            'metadata.directionId': 'directionId',
            'metadata.tripId': 'tripId'
        }, inplace=True)

        df['timestamp'] = pd.to_datetime(df['timestamp'])
        df['hour'] = df['timestamp'].dt.hour
        df['day_of_week'] = df['timestamp'].dt.dayofweek

        for col in ['route_encoded', 'stop_encoded', 'directionId', 'delay']:
            df[col] = pd.to_numeric(df[col], errors='coerce')

        df = df.sort_values(by=['tripId', 'timestamp'])
        df['input_delay'] = df.groupby('tripId')['delay'].shift(1)
        df = df.dropna()

        print(f"📊 Data ready: {len(df)} rows.")

        features = ['route_encoded', 'stop_encoded',
                    'directionId', 'hour', 'day_of_week', 'input_delay']
        target = 'delay'

        X = df[features]
        y = df[target]

        X = X.rename(columns={'input_delay': 'delay'})

        print("🚀 Starting model training...")

        model = xgb.XGBRegressor(
            n_estimators=100,
            learning_rate=0.1,
            max_depth=6,
            random_state=42,
        )

        model.fit(X, y)

        print("✅ Model trained successfully!")

        model_path = 'aurabus_brain_v1.json'
        model.save_model(model_path)
        print(f"💾 Model saved in {model_path}")
        return True

    except Exception as e:
        print(f"❌ ERROR: Unable to read the DB. Reason: {e}")
        return False
