require 'spec_helper'
require 'uri'

describe ToRdf do

  include ToRdf

  it "maps Ruby values to RDF/Turtle values" do
    node_to_s('string').should eq('"""string"""')
    node_to_s(1).should eq("1")
    node_to_s(DateTime.new(2012, 4, 2)).should eq('"2012-04-02T00:00:00+00:00"^^xsd:dateTime')
    node_to_s(URI('http://example.com')).should eq('<http://example.com>')
    lambda { node_to_s(nil) }.should raise_error
  end

  it "deals correctly with empty objects" do
    class Foo1
      include ToRdf
    end
    Foo1.new.to_rdf.should eq(nil)
  end

  it "maps Ruby objects to RDF/Turtle" do
    class Foo2
      include ToRdf
      def name
        "blah"
      end
      def uri
        URI("http://example.com")
      end
      def type_uri
        URI("http://example.com/Foo")
      end
      def rdf_mapping
        { "foo:name" => name }
      end
    end

    lambda { Foo2.new.to_rdf }.should raise_error # namespace 'foo' not defined

    class Foo2
      def namespaces
        super.merge 'foo' => 'http://example.com/ontology/'
      end
    end

    Foo2.new.to_rdf.should eq <<EOF
@prefix dc11: <http://purl.org/dc/elements/1.1/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix dc: <http://purl.org/dc/terms/> .
@prefix foo: <http://example.com/ontology/> .

<http://example.com>
	a <http://example.com/Foo> ;
	foo:name """blah""" ;
	.
EOF
  end

  it "can serialize a list of objects to RDF/Turtle" do
    class Foo3
      include ToRdf
      def namespaces
        super.merge 'foo' => 'http://example.com/ontology/'
      end
      def uri
        URI("http://example.com")
      end
      def type_uri
        URI("http://example.com/Foo")
      end
    end

    ToRdf.to_rdf([Foo3.new, Foo3.new]).should eq <<EOF
@prefix dc11: <http://purl.org/dc/elements/1.1/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix dc: <http://purl.org/dc/terms/> .
@prefix foo: <http://example.com/ontology/> .

<http://example.com>
	a <http://example.com/Foo> ;
	.
<http://example.com>
	a <http://example.com/Foo> ;
	.
EOF
  end

end
