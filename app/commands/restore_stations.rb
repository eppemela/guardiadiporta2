class RestoreStations

  ATTRIBUTES_MAPPING = {
    'id' => ['id', 'i'],
    'name' => ['name', 's'],
    'created_at' => ['created_at', 'datetime'],
    'updated_at' => ['updated_at', 'datetime'],
    'mac_addr' => ['mac_addr', 's'],
    'last_seen' => ['last_seen', 'datetime']
  }

  def initialize(filename)
    @filename = filename
  end


  def perform!
    model_class.destroy_all
    records.each do |record|
      attributes = map_attributes(record)
      unless attributes['mac_addr'] == ""
        model_class.create!(attributes)
      end
    end
  end

  private

  attr_reader :filename

  def map_attributes(record)
    {}.tap do |attributes|
      attributes['ignore'] = convert_boolean("#{record['ignore']}")

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
    when "t"
      then return true
    when "f"
      then return false
    end
  end

  def model_class
    Station
  end

end
