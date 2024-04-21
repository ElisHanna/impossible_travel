from django.urls import path, re_path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    re_path(r'^directions/$', views.DirectionListView.as_view(), name='directions'),
    re_path(r'^direction/(?P<pk>\d+)$', views.DirectionDetailView.as_view(), name='direction-detail')
]