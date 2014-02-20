# DateTime picker using bootstrap-datepicker for the time part
# requires `date_time_attribute` gem and active on the attribute
#   http://stackoverflow.com/a/20317763/2866660
#   https://github.com/einzige/date_time_attribute
class DatePickerTimeInput < SimpleForm::Inputs::StringInput
  def input
    # date format must match datepicker's, see app/assets/application.js
    value = @builder.object.send attribute_name
    date_options = {as: :string, type: 'date', class: 'input-small datepicker', value: value.try {|e| e.strftime('%Y-%m-%d')}}
    time_options = {as: :string, type: 'time', class: 'input-mini', value: value.try {|e| e.strftime('%H:%M')}}
    @builder.input_field("#{attribute_name}_date", input_html_options.merge(date_options)) + ' ' +
    @builder.input_field("#{attribute_name}_time", input_html_options.merge(time_options))
    # time_select requires a date_select
    #@builder.time_select("#{attribute_name}_time", {ignore_date: true}, input_html_options.merge(time_options))
  end
end
