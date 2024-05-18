from django.utils.translation import gettext_lazy as _
from django.shortcuts import render, redirect
from django.views import generic
from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.http import HttpResponseRedirect
from django.urls import reverse, reverse_lazy
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.contrib.auth.decorators import login_required
from datetime import date
from .models import Area, Direction, Entertaiment, Hotel, Tour, Profile, User
from .forms import CreateTourFormUser, NewUserForm, UserEditForm, ProfileEditForm
from django.contrib import messages
from django.contrib.messages.views import SuccessMessageMixin
from django.contrib.auth import login

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

class TourCreate(CreateView):
    model = Tour
    form_class = CreateTourFormUser
    template_name = 'touring/create_tour_form.html'
    success_url = reverse_lazy('my-tours')
    

    def get_form_kwargs(self):
        kwargs = super().get_form_kwargs()
        kwargs.update({
            'user_info':self.request.user
        })
        return kwargs
    
    def create_tour_user(self, request):
        tour = Tour(request)
        if request.method == 'POST':
            form = CreateTourFormUser(request.POST)
            if form.is_valid():
                tour.checkin_date = form.cleaned_data['checkin_date']
                tour.checkout_date = form.cleaned_data['checkout_date']
                tour.save()
                return HttpResponseRedirect(reverse('my-tours'))
            else:
                form = CreateTourFormUser()
            return render(request, 'touring/create_tour_form.html', {'form':form, 'tour':tour})  

class TourUpdate(UpdateView):
    model = Tour

    fields = ['hotel', 'checkin_date', 'checkout_date', 'entertaiments']
    template_name = 'touring/update_tour_form.html'
    success_url = reverse_lazy('my-tours')

class TourDelete(DeleteView):
    model = Tour
    template_name = 'touring/tour_confirm_delete.html'
    success_url = reverse_lazy('my-tours')
    

def register_request(request):
    if request.method == 'POST':
        form = NewUserForm(request.POST)
        if form.is_valid():
            user=form.save()
            profile = Profile.objects.create(user=user)
            login(request, user)
            messages.success(request, 'Вы успешно зарегистрировались')
            return redirect('index')
        else:
            messages.error(request, 'Что-то пошло не так. Перепроверьте информацию.')
    form = NewUserForm()
    return render(request=request, template_name='registration/new_user_registration.html', context={'register_form':form})

@login_required
def profile_edit(request):
    if request.method =='POST':
        user_form = UserEditForm(instance=request.user, data=request.POST)
        profile_form = ProfileEditForm(instance=request.user.profile, data=request.POST, files=request.FILES)
        if user_form.is_valid() and profile_form.is_valid():
            user_form.save()
            profile_form.save()
            return HttpResponseRedirect(reverse('my_profile'))
    else:
        user_form = UserEditForm(instance=request.user)
        profile_form = ProfileEditForm(instance=request.user.profile)
    return render(request, 'accounts/profile_edit.html', {'user_form': user_form, 'profile_form':profile_form})
    
@login_required
def my_profile(request):
    
    profile = Profile.objects.filter(user=request.user)
    first_name = profile[0].user.first_name
    last_name = profile[0].user.last_name
    email = profile[0].user.email
    date_of_birth = profile[0].date_of_birth
    photo = profile[0].photo
    context = {'first_name' : first_name,
               'last_name' : last_name,
               'email' : email,
               'date_of_birth' : date_of_birth,
               'photo' : photo,
               }
    return render(request, context=context, template_name='accounts/my_profile.html')
    