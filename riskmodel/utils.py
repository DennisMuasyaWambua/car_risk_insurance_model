import joblib

def predict_risk(obd_data):
    model = joblib.load('riskmodel/risk_model.joblib')
    imputer = joblib.load('riskmodel/imputer.joblib')
    cleaned_data = imputer.transform(obd_data)
    return model.predict(cleaned_data)