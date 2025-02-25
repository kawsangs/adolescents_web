import { Controller } from "@hotwired/stimulus"
import imageFile from 'commons/image_file';

export default class extends Controller {
  connect() {
    imageFile.init();
  }
}
