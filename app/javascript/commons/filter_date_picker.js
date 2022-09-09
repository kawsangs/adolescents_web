import moment from 'moment/min/moment-with-locales.min.js';
import "daterangepicker"

export default (function() {
  let tr = {};

  let locales = {
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

  return { init }

  function init() {
    setDefaultLocale();
    initDateRangePicker();
    displayDate();

    onApplyDateRange();
    onCancelDateRange();
  }

  function setDefaultLocale() {
    let locale = $('[data-locale]').data('locale') || 'en';
    tr = locales[locale];

    moment.locale(locale);
  }

  function initDateRangePicker() {
    let options = {
      ranges: customRange(),
      locale: {
        cancelLabel: tr.clear,
        applyLabel: tr.apply,
        customRangeLabel: tr.customRange,
        daysOfWeek: moment.weekdays(),
        monthNames: moment.months()
      },
      alwaysShowCalendars: true,
    }

    let start = getStartDate();
    let end = getEndDate();

    if (!!start && !!end) {
      options.startDate = start;
      options.endDate = end;
    }

    $('#daterange').daterangepicker(options);
  }

  function customRange() {
    let ranges = {};
    ranges[tr.today] = [moment(), moment()];
    ranges[tr.yesterday] = [moment().subtract(1, 'days'), moment().subtract(1, 'days')];
    ranges[tr.last_7_day] = [moment().subtract(6, 'days'), moment()];
    ranges[tr.last_30_day] = [moment().subtract(29, 'days'), moment()];
    ranges[tr.this_month] = [moment().startOf('month'), moment().endOf('month')];
    ranges[tr.last_month] = [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')];

    return ranges;
  }

  function onApplyDateRange() {
    $('#daterange').on('apply.daterangepicker', function(ev, picker) {
      setDates(picker.startDate.format('YYYY-MM-DD'), picker.endDate.format('YYYY-MM-DD'));
      displayDate();
      submitForm();
    });
  }

  function onCancelDateRange() {
    $('#daterange').on('cancel.daterangepicker', function(ev, picker) {
      setDates('', '');
      displayDate();
      submitForm();
    });
  }

  function setDates(startDate, endDate) {
    $('.start-date').val(startDate);
    $('.end-date').val(endDate);
  }

  function getStartDate() {
    return getDate($('.start-date').val());
  }

  function getEndDate() {
    return getDate($('.end-date').val());
  }

  function getDate(date) {
    if (!!date) { return moment(date); }

    date;
  }

  function submitForm() {
    $('.form-search').submit();
  }

  function displayDate() {
    let display = $('#daterange span').data('placeholder');
    let startDate = getStartDate();
    let endDate = getEndDate();

    if (!!startDate && !!endDate) {
      display = `${startDate.format(tr.format)} - ${endDate.format(tr.format)}`;
    }

    $('#daterange span').html(display);
  }
})();
