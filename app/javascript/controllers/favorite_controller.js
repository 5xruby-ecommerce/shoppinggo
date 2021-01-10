import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["icon"]
  
  go(e) {
    e.preventDefault();
    const id = this.data.get('id')
    console.log('id');
  }
}
