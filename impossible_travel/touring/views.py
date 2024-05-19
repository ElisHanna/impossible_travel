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
from .forms import CreateTourFormUser, NewUserForm, UserEditForm, ProfileEditForm, CreateTourFormStaff
from django.contrib import messages
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
    """
    Список доступных вселенных
    """
    model = Direction
    paginate_by = 12

class DirectionDetailView(generic.DetailView):
    """
    Детальный просмотр вселенной
    """
    model = Direction

class AreaListView(generic.ListView):
    """
    Список местностей
    """
    model = Area
    paginate_by = 12

class AreaDetailView(generic.DetailView):
    """
    Детальный просмотр местности
    """
    model = Area

class HotelListView(generic.ListView):
    """
    Список доступных гостиниц
    """
    model = Hotel
    paginate_by = 12

class HotelDetailView(generic.DetailView):
    """
    Подробная информация о гостинице
    """
    model = Hotel

class EntertaimentListView(generic.ListView):
    """
    Список вариантов досуга
    """
    model = Entertaiment
    paginate_by = 12

class BookedToursByUserListView(LoginRequiredMixin, generic.ListView):
    """
    Список туров, забронированных пользователем
    """
    model=Tour
    template_name = 'touring/tour_list_booked_user.html'
    paginate_by = 5

    def get_queryset(self):
        return Tour.objects.filter(tourist=self.request.user, checkout_date__gt=date.today()).order_by('checkin_date')
    
class TourListForStaffView(PermissionRequiredMixin, generic.ListView):
    """
    Список всех туров всех пользователей (доступно только персоналу)
    """
    model=Tour
    permission_required = 'touring.can_view'
    template_name = 'touring/staff_templates/tour_list_staff.html'
    paginate_by = 5

class TourCreate(CreateView):
    """
    Создание клиентом нового тура 
    """
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
        
class StaffTourCreate(PermissionRequiredMixin, CreateView):
    """
    Создание тура персоналом для клиента
    """
    
    permission_required = 'touring.can_view'
    model = Tour
    form_class = CreateTourFormStaff
    template_name = 'touring/staff_templates/staff_create_tour_form.html'
    success_url = reverse_lazy('staff-tours')
        
    def create_tour_user(self, request):
        tour = Tour(request)
        if request.method == 'POST':
            form = CreateTourFormStaff(request.POST)
            if form.is_valid():
                tour.checkin_date = form.cleaned_data['checkin_date']
                tour.checkout_date = form.cleaned_data['checkout_date']
                tour.save()
                return HttpResponseRedirect(reverse('staff-tours'))
            else:
                form = CreateTourFormStaff()
            return render(request, 'touring/staff_create_tour_form.html', {'form':form, 'tour':tour}) 

class TourUpdate(UpdateView):
    """
    Изменение тура клиентом
    """
    model = Tour

    fields = ['hotel', 'checkin_date', 'checkout_date', 'entertaiments']
    template_name = 'touring/update_tour_form.html'
    success_url = reverse_lazy('my-tours')

class StaffTourUpdate(PermissionRequiredMixin, UpdateView):
    """
    Изменение тура персоналом
    """
    
    permission_required = 'touring.can_view'
    model = Tour
    fields = ['tourist', 'hotel', 'checkin_date', 'checkout_date', 'entertaiments']
    template_name = 'touring/staff_templates/staff_update_tour_form.html'
    success_url = reverse_lazy('staff-tours')

class TourDelete(DeleteView):
    """
    Удаление тура клиентом
    """
    model = Tour
    template_name = 'touring/tour_confirm_delete.html'
    success_url = reverse_lazy('my-tours')

class StaffTourDelete(PermissionRequiredMixin, DeleteView):
    """
    Удаление тура персоналом
    """
    
    permission_required = 'touring.can_view'
    model = Tour
    template_name = 'touring/staff_templates/staff_tour_confirm_delete.html'
    success_url = reverse_lazy('staff-tours')

def register_request(request):
    """
    Регистрация нового пользователя
    """
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
    """
    Внесение изменений в профиль
    """
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
    """
    Просмотр своего профиля
    """
    profile = Profile.objects.get(user = request.user)
    context = {
                'first_name' : profile.user.first_name,
                'last_name' : profile.user.last_name,
                'email' : profile.user.email,
                'date_of_birth' : profile.date_of_birth,
                'photo' : profile.photo,
            }
    return render(request, context=context, template_name='accounts/my_profile.html')
    