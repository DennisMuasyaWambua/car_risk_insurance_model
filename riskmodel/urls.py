from django.urls import path
from .views import DriverRiskView

urlpatterns =[
    path("predict/", DriverRiskView.as_view(), name="predict"),
]