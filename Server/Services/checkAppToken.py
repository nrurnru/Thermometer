from Models.Constants import Constants

def checkAppToken(headers) -> bool:
    return headers.get('appToken') == Constants.appToken