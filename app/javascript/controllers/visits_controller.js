import { Controller } from "@hotwired/stimulus"
import moment from 'moment/min/moment-with-locales.min.js';
import "daterangepicker"

export default class extends Controller {
  tr = {};

  locales = {
    en: {
      today: 'Today',
      yesterday: 'Yesterday',
      last_7_day: 'Last 7 Days',
      last_30_day: 'Last 30 Days',
      this_month: 'This Month',
      last_month: 'Last Month',
      customRange: 'Custom Range',
      clear: 'Clear',
      apply: 'Apply',
      format: 'MMMM D, YYYY'
    },
    km: {
      today: 'ថ្ងៃនេះ',
      yesterday: 'ម្សិលមិញ',
      last_7_day: '7 ថ្ងៃចុងក្រោយ',
      last_30_day: '30 ថ្ងៃចុងក្រោយ',
      this_month: 'ខែនេះ',
      last_month: 'ខែមុន',
      customRange: 'កំណត់ដោយខ្លួនឯង',
      clear: 'កំណត់ឡើងវិញ',
      apply: 'រួចរាល់',
      format: 'DD MMMM YYYY'
    }
  };

  connect() {
    this.setDefaultLocale();
    this.initDateRangePicker();
    this.displayDate();

    this.onApplyDateRange();
    this.onCancelDateRange();
  }

  setDefaultLocale() {
    let locale = $('[data-locale]').data('locale') || 'en';
    this.tr = this.locales[locale];

    moment.locale(locale);
  }

  initDateRangePicker() {
    let options = {
      ranges: this.customRange(),
      locale: {
        cancelLabel: this.tr.clear,
        applyLabel: this.tr.apply,
        customRangeLabel: this.tr.customRange,
        daysOfWeek: moment.weekdays(),
        monthNames: moment.months()
      },
      alwaysShowCalendars: true,
    }

    let start = this.getStartDate();
    let end = this.getEndDate();

    if (!!start && !!end) {
      options.startDate = start;
      options.endDate = end;
    }

    $('#daterange').daterangepicker(options);
  }

  customRange() {
    let ranges = {};
    ranges[this.tr.today] = [moment(), moment()];
    ranges[this.tr.yesterday] = [moment().subtract(1, 'days'), moment().subtract(1, 'days')];
    ranges[this.tr.last_7_day] = [moment().subtract(6, 'days'), moment()];
    ranges[this.tr.last_30_day] = [moment().subtract(29, 'days'), moment()];
    ranges[this.tr.this_month] = [moment().startOf('month'), moment().endOf('month')];
    ranges[this.tr.last_month] = [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')];

    return ranges;
  }

  onApplyDateRange() {
    let self = this;

    $('#daterange').on('apply.daterangepicker', function(ev, picker) {
      self.setDates(picker.startDate.format('YYYY-MM-DD'), picker.endDate.format('YYYY-MM-DD'));
      self.displayDate();
      self.submitForm();
    });
  }

  onCancelDateRange() {
    let self = this;

    $('#daterange').on('cancel.daterangepicker', function(ev, picker) {
      self.setDates('', '');
      self.displayDate();
      self.submitForm();
    });
  }

  setDates(startDate, endDate) {
    $('.start-date').val(startDate);
    $('.end-date').val(endDate);
  }

  getStartDate() {
    return this.getDate($('.start-date').val());
  }

  getEndDate() {
    return this.getDate($('.end-date').val());
  }

  getDate(date) {
    if (!!date) { return moment(date); }

    date;
  }

  submitForm() {
    $('.form-search').submit();
  }

  displayDate() {
    let display = $('#daterange span').data('placeholder');
    let startDate = this.getStartDate();
    let endDate = this.getEndDate();

    if (!!startDate && !!endDate) {
      display = `${startDate.format(this.tr.format)} - ${endDate.format(this.tr.format)}`;
    }

    $('#daterange span').html(display);
  }
}
