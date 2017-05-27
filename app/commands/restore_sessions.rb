class RestoreSessions

  ATTRIBUTES_MAPPING = {
    'start' => ['start', 'datetime'],
    'end' => ['end', 'datetime'],
    'duration' => ['duration', 'i'],
    'created_at' => ['created_at', 'datetime'],
    'updated_at' => ['updated_at', 'datetime']
  }

  def initialize(filename)
    @filename = filename
  end


  def perform!
    model_class.destroy_all
    records.each do |record|
      attributes = map_attributes(record)
      unless attributes['station'].nil?
        model_class.create!(attributes)
      end

    end
  end

  private

  attr_reader :filename

  def map_attributes(record)
    {}.tap do |attributes|
      attributes['open'] = convert_boolean("#{record['open']}")
      begin
        attributes['station'] = Station.find("#{record['station_id']}")
      rescue ActiveRecord::RecordNotFound
        attributes['station'] = nil
      end
      record.keys.each do |key|
        attribute = ATTRIBUTES_MAPPING[key]
        attributes[attribute[0]] = record[key].send("to_#{attribute[1]}") if attribute.present?
      end
    end
  end

  def records
    return if @records.present?
    File.open(filename) do |f|
      @records = JSON.parse(f.read)['RECORDS']
    end
  end

  def convert_boolean(value)
    case value
    when "1"
      then return true
    when "0"
      then return false
    end
  end

  def model_class
    Session
  end

end
