from typing import Any
from django.utils.translation import gettext_lazy as _
from django.db.models.query import QuerySet
from django.shortcuts import render, get_object_or_404
from django.views import generic
from django.views.generic.edit import CreateView, UpdateView, DeleteView, FormView
from django.http import HttpResponseRedirect
from django.urls import reverse, reverse_lazy
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
import datetime
from datetime import date
from .models import Area, Commodity, Direction, Entertaiment, Hotel, Tour
from .forms import CreateTourFormUser

def index(request):
    """
    Отображение главной страницы сайта
    """
    num_directions=Direction.objects.all().count()
    num_areas=Area.objects.all().count()
    num_entertaiments=Entertaiment.objects.all().count()
    num_hotels=Hotel.objects.all().count()
    num_visits=request.session.get('num_visits', 0)
    request.session['num_visits'] = num_visits+1
    context = {'num_directions':num_directions,
               'num_areas':num_areas,
               'num_entertaiments':num_entertaiments,
               'num_hotels':num_hotels,
               'num_visits':num_visits,
               }

    return render(request, 'index.html', context=context)

class DirectionListView(generic.ListView):
    model = Direction

class DirectionDetailView(generic.DetailView):
    model = Direction

class AreaListView(generic.ListView):
    model = Area

class AreaDetailView(generic.DetailView):
    model = Area

class HotelListView(generic.ListView):
    model = Hotel

class HotelDetailView(generic.DetailView):
    model = Hotel

class EntertaimentListView(generic.ListView):
    model = Entertaiment

class BookedToursByUserListView(LoginRequiredMixin, generic.ListView):
    model=Tour
    template_name = 'touring/tour_list_booked_user.html'

    def get_queryset(self):
        return Tour.objects.filter(tourist=self.request.user).filter(checkout_date__gt=date.today()).order_by('checkin_date')
    
class TourListForStaffView(PermissionRequiredMixin, generic.ListView):
    model=Tour
    permission_required = 'touring.can_view'
    template_name = 'touring/tour_list_staff.html'

class TourCreate(FormView):
    form_class = CreateTourFormUser
    template_name = 'touring/create_tour_form.html'
    success_url = reverse_lazy('my-tours')

class TourUpdate(UpdateView):
    model = Tour
    fields = "__all__"
    template_name = 'touring/update_tour_form.html'

class TourDelete(DeleteView):
    model = Tour
    template_name = 'touring/tour_confirm_delete.html'
    success_url = reverse_lazy('index')
