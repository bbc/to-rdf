to-rdf
======

A small gem to serialize Ruby objects as RDF.


Example use
-----------

    require 'to_rdf'
    require 'uri'

    class Actor

      include ToRdf

      attr_accessor :name, :id

      def uri
        URI("http://example.com/actors/#{id}")
      end

      def type_uri
        URI("http://example.com/schema/Actor")
      end

      def rdf_mapping
        {
          "foaf:name" => name
        }
      end
    end

    actor = Actor.new
    actor.id = 1
    actor.name = "John Doe"
    actor.to_rdf
