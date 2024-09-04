python -m venv venv

@REM source venv/bin/activate

CALL ./venv\scripts\activate.bat

pip install -r requirements.txt

fastapi dev app/main.py

pause