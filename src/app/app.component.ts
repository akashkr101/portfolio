import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { FooterComponent } from './footer/footer.component';
import { HeaderComponent } from './header/header.component';
import { BodyHomeComponent } from './body-home/body-home.component';
import { HomeComponent } from './home/home.component';
import { MenuComponent } from './menu/menu.component';
import { NavComponent } from './nav/nav.component';
import { UsersComponent } from './users/users.component';
import { SkillsComponent } from './skills/skills.component';
import { SocialMediaComponent } from './social-media/social-media.component';
import { ProfileComponent } from './profile/profile.component';
import { ExperienceComponent } from './experience/experience.component';
import { ContactComponent } from './contact/contact.component';
import { EducationComponent } from './education/education.component';
import { ProjectsComponent } from './projects/projects.component';
import { PersonalskillsComponent } from './personalskills/personalskills.component';






@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, BodyHomeComponent, FooterComponent, HeaderComponent, HomeComponent, MenuComponent, 
    NavComponent, UsersComponent, SkillsComponent, SocialMediaComponent, ProfileComponent, ExperienceComponent, ContactComponent, EducationComponent, ProjectsComponent,
    PersonalskillsComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'portfolio';
  data = [
    {
    name: 'akash',
    age: 40,
    email: 'xyz@gmail.com'
    },

    {
    name: 'avinash',
    age: 20,
    email: 'xyz@gmail.com'
    },

    {
    name: 'jayesh',
    age: 10,
    email: 'xyz@gmail.com'
    },
  ];

  getUserValue(value:any)
    {
      console.warn(value);
    }
}
