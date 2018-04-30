import { Controller } from "stimulus";

export default class extends Controller { 
  connect() {
    console.log('on screen connected...');
  }
  filter(e) {
    e.preventDefault();
    const query = e.target.value.toLowerCase();
    if (query.length > 3) {
      $('.trail').filter((_, card) => { 
        const content = card.textContent.toLowerCase()
        return content.indexOf(query) < 0;
      }).addClass('hide')

      $('.trail').filter((_, card) => { 
        const content = card.textContent.toLowerCase()
        return content.indexOf(query) > 0;
      }).removeClass('hide')
    }

    if (query === '' ) {
      $('.trail').removeClass('hide');
    }
  }
}
