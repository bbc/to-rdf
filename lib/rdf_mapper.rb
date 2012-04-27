require 'uri'

module RdfMapper

  def to_rdf
    return unless uri
    return if rdf_mapping.empty?
    rdf = "<#{uri}>\n"
    rdf += "\ta #{type_uri} ;\n" if type_uri
    rdf_mapping.keys.each do |prop|
      value = rdf_mapping[prop]
      next unless value
      if value.respond_to? :each
        value.each { |v| rdf += "\t#{prop} " + node_to_s(v) }
      else
        rdf += "\t#{prop} " + node_to_s(value)
      end
    end
    rdf += "\t.\n"
  end

  def node_to_s(node)
    if node.class == String
      s = "\"\"\"#{node.gsub('"', '\"')}\"\"\" ;\n"
    elsif node.class == Fixnum
      s = "#{node} ;\n"
    elsif node.class == DateTime
      s = "\"#{node}\"^^xsd:dateTime ;\n"
    elsif node.class == URI::HTTP
      s = "<#{node.to_s}> ;\n"
    elsif node.class == TrueClass
      s = "\"true\"^^xsd:boolean ;\n"
    elsif node.class == FalseClass
      s = "\"false\"^^xsd:boolean ;\n"
    elsif node.respond_to? :uri
      s = "<#{node.uri}> ;\n"
    else
      s = nil
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
