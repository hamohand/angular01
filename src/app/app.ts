import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [],
  templateUrl: './app.html',
  styleUrls: ['./app.css'] // Correction de styleUrl -> styleUrls
})
export class App {
  protected title = 'angular01';
}
