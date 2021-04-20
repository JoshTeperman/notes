# XML "Remote Procedure Call"
# http://xmlrpc.com/
# https://searchapparchitecture.techtarget.com/definition/Remote-Procedure-Call-RPC

# What is a procedure call?
# A procedure call is the name of a procedure, its parameters, and the result it returns. It is the way a computer asks/calls questions of itself and receives answers in a "response".
# A procedure call is spawned every time you click a mouse on a computer -> LocateMouse, IdentifyClickTarget, PrintFile etc etc
# Every program is just a single procedure called main, every operating system has a main procedure called a kernel.
# There's a top level to every program that sits in a loop waiting for something to happen and then distributes control to a hierarchy of procedures that respond.
# This is at the heart of interactivity and networking, it's at the heart of software.

# What is RPC?
# http://scripting.com/davenet/1998/07/14/xmlRpcForNewbies.html
# An extension to the procedure call idea. It creates connections between procedures running in different applications, on different operating systems, on different machines.
# "Remote calls are "marshalled" into a format that can be understood on the other side of the connection."
# "The value in a standardized cross-platform approach for RPC is that it allows UNIX machines to talk to Windows machines and vice-versa."

# What is XML-RPC?
# There are a number formats possible for encoding data. XML-RPC uses XML as the marshalling format, since it's human & machine-readable, and relatively easy to marshall the internal procedure calls to remote format.
# "Its distinctive feature is its simplicity compared to other approaches like SOAP and CORBA."
# "A spec and a set of implementations that allow software running on disparate operating systems, running in different environments to make procedure calls (invoke functions) over the internet"
# "It's remote procedure calling (function invoking) using HTTP as the transport and XML as the encoding. "
# "XML-RPC is designed to be as simple as possible, while allowing complex data structures to be transmitted, processed and returned."
# First iteration of XML-RPC was in 1998 in Frontier (http://frontier.userland.com/stories/storyReader$101)

# Spec:
# XML-RPC is a Remote Procedure Calling protocol that works over the Internet.
# An XML-RPC message is an HTTP-POST request.
# The body of the request is in XML.
# A procedure executes on the server and the value it returns is also formatted in XML.
# Procedure parameters can be scalars, numbers, strings, dates, etc.; and can also be complex record and list structures.

# Ruby XML-RPC

# Example. Initialize an RPC server and call a remote procedure.

#   # Make an object to represent the XML-RPC server.
#   server = XMLRPC::Client.new( "xmlrpc-c.sourceforge.net", "/api/sample.php")
#
#   # Call the remote server and get our result
#   result = server.call("sample.sumAndDifference", 5, 3)
#
#   sum = result["sum"]
#   difference = result["difference"]


# == Features of XMLRPC for Ruby
#
# * Extensions
#   * Introspection
#   * multiCall
#   * optionally nil values and integers larger than 32 Bit
#
# * Server
#   * Standalone XML-RPC server
#   * CGI-based (works with FastCGI)
#   * Apache mod_ruby server
#   * WEBrick servlet
#
# * Client
#   * synchronous/asynchronous calls
#   * Basic HTTP-401 Authentication
#   * HTTPS protocol (SSL)
#
# * Parsers
#   * REXML (XMLParser::REXMLStreamParser)
#     * Not compiled (pure ruby)
#     * See ruby standard library
#   * libxml (LibXMLStreamParser)
#     * Compiled
#     * See https://rubygems.org/gems/libxml-ruby/
#
# * General
#   * possible to choose between XMLParser module (Expat wrapper) and REXML (pure Ruby) parsers
#   * Marshalling Ruby objects to Hashes and reconstruct them later from a Hash
#   * SandStorm component architecture XMLRPC::Client interface


# Similarly, the XMLRPC implementation that is included in the Ruby standard library supports several XML parsing options.
# Each of these methods of parsing XML has an associated parser class; there is one class for parsing the XML as a stream and another for parsing it as a DOM tree.
# But there is no separate subclass of some XMLRPC class for each parsing technique.
# Instead, the XMLRPC code simply holds on to the class of the chosen XML parser and manufactures new instances of the parser from the class object as required.

module XMLRPC
  module ParserWriterChooseMixin
    def set_writer(writer)
      @writer = writer
      self
    end

    def set_parser(parser)
      @parser = parser
      self
    end

    def create
      set_writer(CONFIG::DEFAULT_WRITER.new) if @create.nil?
      @create
    end

    def parser
      set_parser(CONFIG::DEFAULT_PARSER.new) if @parser.nil?
      @parser
    end
  end

  module Client
  # Provides remote procedure calls to a XML-RPC server.
  #
  # After setting the connection-parameters with XMLRPC::Client.new which
  # creates a new XMLRPC::Client instance, you can execute a remote procedure
  # by sending the XMLRPC::Client#call or XMLRPC::Client#call2
  # message to this new instance.

  # require "xmlrpc/client"
  #
  #     server = XMLRPC::Client.new("www.ruby-lang.org", "/RPC2", 80)
  #     begin
  #       param = server.call("michael.add", 4, 5)
  #       puts "4 + 5 = #{param}"
  #     rescue XMLRPC::FaultException => e
  #       puts "Error:"
  #       puts e.faultCode
  #       puts e.faultString
  #     end

    USER_AGENT = "XMLRPC::Client (Ruby #{RUBY_VERSION})"
    include ParserWriterChooseMixin

    def initialize(host=nil, path=nil, port=nil, proxy_host=nil, proxy_port=nil, user=nil, password=nil, use_ssl=nil, timeout=nil)
      @host       = host || "localhost"
      @path       = path || "/RPC2"
      @proxy_host = proxy_host
      @proxy_port = proxy_port
      @proxy_host ||= 'localhost' if @proxy_port != nil
      @proxy_port ||= 8080 if @proxy_host != nil
      @use_ssl    = use_ssl || false
      @timeout    = timeout || 30
      if use_ssl
        require "net/https"
        @port = port || 443
      else
        @port = port || 80
      end
      @user, @password = user, password
      @port = @port.to_i if @port != nil
      @proxy_port = @proxy_port.to_i if @proxy_port != nil

      # HTTP object for synchronous calls
      @http = net_http(@host, @port, @proxy_host, @proxy_port)
      @http.use_ssl = @use_ssl if @use_ssl
      @http.read_timeout = @timeout
      @http.open_timeout = @timeout

      @parser = nil
      @create = nil
    end

    def call(method, *args)
      # Invokes the method named +method+ with the parameters given by +args+ on the XML-RPC server.
      # The +method+ parameter is converted into a String and should be a valid XML-RPC method-name.
      # Each parameter of +args+ must be of one of Integer, boolean, String, Symbol, Float, Hash, Struct, Array, Date, Time, Base64, a Ruby object which class includes XMLRPC::Marshallable (That object is converted into a hash, with one additional key/value pair <code>___class___</code> which contains the class name for restoring that object later)
      # The method returns the return-value from the Remote Procedure Call.
      # The type of the return-value is one of the types shown above.
      # If the remote procedure returned a fault-structure, then a XMLRPC::FaultException exception is raised, which has two accessor-methods +faultCode+ an Integer, and +faultString+ a String.

      ok, param = call2(method, *args)
      if ok
        param
      else
        raise param
      end
    end

    def call2(method, *args)
    # This method returns an array of two values. The first value indicates if the second value is +true+ or an XMLRPC::FaultException
      request = create.methodCall(method, *args) # ParserWriterChooseMixin
      data = do_rpc(request)
      parser.parseMethodResponse(data) # ParserWriterChooseMixin
    end

    private

    def do_rpc(request, async=false)
      header = {
        'User-Agent' => USER_AGENT,
        'Content-Type' => 'text/xml; charset=utf-8',
        'Content-Length' => request.bytesize.to_s,
        'Connection' => async ? 'close' : 'keep-alive'
      }

      header['Cookie'] = @cookie if @cookie
      header.update(@http_header_extra) if @http_header_extra
      header['Authorization'] = @auth unless @auth.nil?

      resp = nil
      @http_last_response = nil

      if async
        # use a new HTTP object for each call
        http = dup_net_http
        http.start { response = http.request_post(@path, request, header) }
      else
        # reuse the HTTP object for each call. => connection alive is possible # we must start connection explicitly first time so that http.request does not assume that we don't want keepalive
        @http.start unless @http.started
        resp = @http.request_post(@path, request, header)
      end

      @http_last_response = resp
      data = resp.body

      if resp.code = '401'
        raise "Authorization Failed. \nHTTP-Error: #{resp.code} #{resp.message}"
      elsif response.code[0, 1] != '2'
        raise "HTTP-Error: #{resp.code} #{resp.message}"
      end

      ct_expected = resp['Content-Type'] || 'text/xml'
      ct = parse_content_type(ct_expected).first
      case ct
      when 'text/xml', 'application/xml'
        # OK
      else
        raise "Wrong content-type (received '#{ct}' but expected 'text/xml' or 'application/xml')"
      end

      raise 'No data' if data.nil?

      expected = resp['Content-Length'] || '<unknown>'
      raise "Wrong size. Was #{data.bytesize}, should be #{expected}" if data.bytesize == 0

      parse_set_cookies(resp.get_fields('Set-ookie'))

      data
    end

    def net_http(host, port, proxy_host, proxy_port)
      Net::HTTP.new(host, port, proxy_host, proxy_port)
    end
  end

  module Server
    def process(data)
      method, params = parser().parseMethodCall(data)
      handle(method, *params)
    end
  end

  module Parser
    module XMLParser
      class AbstractTreeParser
        def parseMethodResponse(str)
          methodResponse_document(createCleanedTree(str))
        end

        def parseMethodCall(str)
          methodCall_document(createCleanedTree(str))
        end

        private

        def methodResponse_document(node)
          assert(node.nodeType == XML::SimpleTree::Node::DOCUMENT)
          hasOnlyOneChild(node, "methodResponse")

          methodResponse(node.firstChild)
        end

        def methodCall_document(node)
          assert(node.nodeType == XML::SimpleTree::Node::DOCUMENT)
          hasOnlyOneChild(node, "methodCall")

          methodCall(node.firstChild)
        end

        def string
        end

        def base64
        end

        def methodCall(node)
          nodeMustBe(node, 'methodCall')
          assert((1..2).include?(node.childNodes.to_a.size))
          name = methodName(node[0])

          if node.childNodes.to_a.size
            parameters = params(node[1])
          else # no parameters given
            parameters = []
          end

          [name, parameters]
        end

        def methodResponse
          nodeMustBe(node, 'methodResponse')
          hasOnlyOneChild(node, %(params fault))
          child = node.firstChild

          case childe.nodeName
          when 'params'
            [true, params(child, false)]
          when 'fault'
            [false, fault(child)]
          else
            raise 'unexpected error'
          end
        end
        # etc
      end

      class AbstractStreamParser
        def parseMethodResponse(str)
          parser = @parser_class.new
          parser.parse(str)

          [true, parser.params[0]]
        end

        def parseMethodCall(str)
          parser = @parser_class.new
          parser.parse(str)

          [parser.method_name, parser.params]
        end
      end

      module StreamParserMixin
      end

      class REXMLStreamParser < AbstractStreamParser
        def initialize
          require "rexml/document"
          @parser_class = StreamListener
        end

        class StreamListener
          include StreamParserMixin

          def parse(str)
            REXML::Document.parse_stream(str, self)
          end
        end
      end

      class LibXMLStreamParser < AbstractStreamParser
        def initialize
          require 'libxml'
          @parser_class = LibXMLStreamListener
        end

        class LibXMLStreamListener
          include StreamParserMixin

          def parse(str)
            parser = LibXML::XML::SaxParser.string(str)
            parser.parse(str)
          end
        end
      end

      CLASSES = [REXMLStreamParser, LibXMLStreamParser].freeze
    end
  end

  class Marshal
    # m = XMLRPC::Marshal.new(parser) -> parser must be an instance of a class from XMLRPC::Parser
    # m.load_response, m.dump_response, m.load_call, m.load_response

    def initialize(parser = nil, writer = nil)
      @parser = parser
      @writer = writer
    end

    def load_call(string_or_readable)
      parser.parseMethodCall(string_or_readable)
    end
  end
end
