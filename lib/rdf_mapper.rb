require 'uri'

module RdfMapper

  def to_rdf
    return unless uri
    return if rdf_mapping.empty?
    rdf = node_to_s(uri) + "\n"
    rdf += "\ta #{node_to_s(type_uri)} ;\n" if type_uri
    rdf_mapping.keys.each do |prop|
      value = rdf_mapping[prop]
      next unless value
      if value.respond_to? :each
        value.each { |v| rdf += "\t#{prop} " + node_to_s(v) + " ;\n" }
      else
        rdf += "\t#{prop} " + node_to_s(value) + " ;\n"
      end
    end
    rdf += "\t.\n"
  end

  def node_to_s(node)
    if node.class == String
      s = "\"\"\"#{node.gsub('"', '\"')}\"\"\""
    elsif node.class == Fixnum
      s = "#{node}"
    elsif node.class == DateTime
      s = "\"#{node}\"^^xsd:dateTime"
    elsif node.class.ancestors.include? URI::Generic
      s = "<#{node.to_s}>"
    elsif node.class == TrueClass
      s = "\"true\"^^xsd:boolean"
    elsif node.class == FalseClass
      s = "\"false\"^^xsd:boolean"
    elsif node.respond_to? :uri
      s = "<#{node.uri}>"
    else
      raise Exception.new("No mapping for #{node}")
    end
    s
  end

  def uri
    nil
  end

  def type_uri
    nil
  end

  def rdf_mapping
    {}
  end
end
