# 1. Usiamo un'immagine Python leggera (Slim) per risparmiare spazio
FROM python:3.14-slim

# 2. Impostiamo la cartella di lavoro dentro il container
WORKDIR /app

# 3. Copiamo PRIMA solo i requirements (Trucco per la cache di Docker)
# Se cambi il codice ma non le librerie, Docker salterà questo passaggio lento.
COPY requirements.txt .

# 4. Installiamo le librerie
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copiamo il resto del codice (main.py, aurabus_brain.json, ecc.)
COPY . .

# 6. Esponiamo la porta 8000 (standard di FastAPI)
EXPOSE 8000

# 7. Il comando di avvio
# uvicorn main:app -> Cerca l'oggetto 'app' nel file 'main.py'
# --host 0.0.0.0 -> Accetta connessioni da fuori (importante per Docker)
# --reload -> Se cambi codice, si riavvia da solo (comodo in sviluppo)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]