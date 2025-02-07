from django.shortcuts import render
from rest_framework.views import APIView
from riskmodel.serializers import EngineSerializer
import pandas as pd
from rest_framework.response import Response
from riskmodel.utils import predict_risk

# Create your views here.
class DriverRiskView(APIView):
      serializer_class = EngineSerializer
      def post(self, request):
          serializer = self.serializer_class(data=request.data)
          if serializer.is_valid():
             validated_engine_rpm = serializer.validated_data['engine_rpm']
             validated_x = serializer.validated_data['g_x']
             validated_y = serializer.validated_data['g_y']
             validated_z = serializer.validated_data['g_z']
             validated_throttle_positions = serializer.validated_data['throttle_position']
             input = pd.DataFrame([{
                        'Engine RPM(rpm)': validated_engine_rpm,
                        ' G(x)': validated_x,
                        ' G(y)': validated_y,
                        ' G(z)': validated_z,
                        'Throttle Position(Manifold)(%)': validated_throttle_positions
                    }])
             prediction = predict_risk(input)
             prediction_percentage = prediction[0]*100
             return Response({"risk": prediction_percentage})
          else:
                return Response(serializer.errors, status=400)


             
               
               


