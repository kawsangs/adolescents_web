import { Controller } from "@hotwired/stimulus"
import logo from 'commons/logo';
import "tinymce"

export default class extends Controller {
  connect() {
    logo.init();
    this.initEditor();
  }

  initEditor() {
    tinymce.init({
      selector: '.tinymce',
      menubar: false,
      plugins: 'anchor autolink charmap codesample emoticons image link lists table visualblocks wordcount checklist mediaembed casechange export formatpainter pageembed linkchecker a11ychecker tinymcespellchecker permanentpen powerpaste advtable advcode tableofcontents footnotes mergetags autocorrect typography inlinecss',
      toolbar: 'undo redo | formatselect | bold italic backcolor table | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat | advcode'
     });
  }
}
