require 'uri'

module RdfMapper

  def to_rdf
    return unless uri
    return if rdf_mapping.empty?
    rdf = turtle_namespaces
    rdf += node_to_s(uri) + "\n"
    rdf += "\ta #{node_to_s(type_uri)} ;\n" if type_uri
    rdf_mapping.keys.each do |prop|
      ns = prop.split(':').first
      raise Exception.new("Namespace \"#{ns}\" is not defined, please override the namespaces method") unless namespaces.has_key? ns
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
      s = (namespaces.has_key? node.split(':').first) ? node : "\"\"\"#{node.gsub('"', '\"')}\"\"\""
    elsif node.class == Fixnum
      s = "#{node}"
    elsif node.class == DateTime
      s = "\"#{node}\"^^xsd:dateTime"
    elsif node.kind_of? URI::Generic
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

  def turtle_namespaces
    turtle = ""
    namespaces.each do |k, v|
      turtle += "@prefix #{k}: <#{v.to_s}> .\n"
    end
    turtle += "\n"
  end

  # To be overridden

  def namespaces
    {
      'dc' => URI('http://purl.org/dc/elements/1.1/'),
      'rdf' => URI('http://www.w3.org/1999/02/22-rdf-syntax-ns#'),
      'rdfs' => URI('http://www.w3.org/2000/01/rdf-schema#'),
      'xsd' => URI('http://www.w3.org/2001/XMLSchema#'),
      'owl' => URI('http://www.w3.org/2002/07/owl#'),
    }
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
