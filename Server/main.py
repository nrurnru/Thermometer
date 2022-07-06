from fastapi import FastAPI, Request
from Models.BaseModel import Temperature
from Models.BaseModel import Humid
from Models.Errors.ErrorFactory import ErrorFactory
from Models.IDResult import IDResult
from Models.ResponseJSON import ResponseJSON
from Models.URLComponents import URLComponents
from Services.checkAppToken import checkAppToken

app = FastAPI()
        
@app.post(URLComponents.temperature)
def temp(request: Request, temperature: Temperature):
    if not checkAppToken(request.headers):
        return ResponseJSON(None, ErrorFactory.tokenError)
    if not temperature.checkRange():
        return ResponseJSON(None, ErrorFactory.valueError)

    return ResponseJSON(IDResult(1), None)

@app.post(URLComponents.humidity)
def temp(request: Request, humid: Humid):
    if not checkAppToken(request.headers):
        return ResponseJSON(None, ErrorFactory.tokenError)
    if not humid.checkRange():
        return ResponseJSON(None, ErrorFactory.valueError)

    return ResponseJSON(IDResult(1), None)
