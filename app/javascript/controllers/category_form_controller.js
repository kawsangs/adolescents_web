import { Controller } from "@hotwired/stimulus"
import logo from 'commons/logo';
import Tagify from "@yaireo/tagify";
import "jquery";
import "libs/jquery.richtext";

export default class extends Controller {
  static targets = [ "tagList", "btnAddQuestion" ]

  connect() {
    logo.init();
    this._initTagTagify();
    this._initEditor();
  }

  appendField(event) {
    event.preventDefault();

    let dom = $(this.btnAddQuestionTarget);
    let time = new Date().getTime();
    let regexp = new RegExp(dom.data('id'), 'g');
    let field = $(dom.data('fields').replace(regexp, time));

    dom.before(field);
  }

  _initEditor() {
    $('.tinymce').richText({
      // text formatting
      bold: true,
      italic: true,
      underline: true,

      // text alignment
      leftAlign: true,
      centerAlign: true,
      rightAlign: true,
      justify: true,

      // lists
      ol: true,
      ul: true,

      // title
      heading: false,

      // fonts
      fonts: false,
      fontList: ["Arial",
        "Arial Black",
        "Comic Sans MS",
        "Courier New",
        "Geneva",
        "Georgia",
        "Helvetica",
        "Impact",
        "Lucida Console",
        "Tahoma",
        "Times New Roman",
        "Verdana"
      ],
      fontColor: false,
      fontSize: false,

      // uploads
      imageUpload: false,
      fileUpload: false,

      // media
      videoEmbed: false,

      // link
      urls: false,

      // tables
      table: true,

      // code
      removeStyles: false,
      code: true,

      // colors
      colors: [],

      // dropdowns
      fileHTML: '',
      imageHTML: '',

      // privacy
      youtubeCookies: false,

      // preview
      preview: false,

      // placeholder
      placeholder: '',

      // dev settings
      useSingleQuotes: false,
      height: 0,
      heightPercentage: 0,
      id: "",
      class: "",
      useParagraph: false,
      maxlength: 0,
      useTabForNext: false,

      // callback function after init
      callback: undefined,
    });
  }

  _initTagTagify() {
    new Tagify(this.tagListTarget, {
      whitelist: $(this.tagListTarget).data('tags'),
      dropdown: { maxItems: 20, classname: "tags-look", enabled: 0, closeOnSelect: false }
    });
  }

  submitForm(e) {
    this._reassignValueWithComma($(this.tagListTarget));
  }

  _reassignValueWithComma(target) {
    if (target.val().length) {
      let transformValue = JSON.parse(target.val()).map(x => x.value);
      target.val(`${transformValue.join(',')}`);
    }
  }
}
