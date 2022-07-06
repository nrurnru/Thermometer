from Models.Errors.ResponseError import ResponseError

class ErrorFactory:
    valueError = ResponseError(100, "Value range error.")
    tokenError = ResponseError(101, "No app token.")