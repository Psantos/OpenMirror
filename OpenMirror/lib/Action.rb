# Classe permettant de modeliser une action suite à un évenement
# 
# Author::    	dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright:: 	Copyright (c) 2010 - dos Santos Pedro.
# Date:: 	25 mars 2010
# Version::	1.2
# :title: 	Action.rb
#-----------------------------------------------------------------------------------------------------------
#
#   Copyright (C) 2010 dos Santos Pedro
# 
#   This file is part of OpenMirror.
# 
#   OpenMirror is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Lesser General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
# 
#   OpenMirror is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Lesser General Public License for more details.
# 
#   You should have received a copy of the GNU Lesser General Public License
#   along with OpenMirror.  If not, see <http://www.gnu.org/licenses/>.
#
#-----------------------------------------------------------------------------------------------------------
begin Dir.chdir(File.join(File.dirname(__FILE__), "..")); $ROOTPATH = Dir.pwd; end unless defined? $ROOTPATH

require 'uri'
require 'net/http'

module OpenMirror
    
  class Action  

    __PATH__ = File.join(File.dirname(__FILE__),"")
    
    # Classe d'exceptions interne
    class ActionError < Exception
    end      
    
    # Patterns de remplacement
    PATTERN_ID          = '@(id)'
    PATTERN_DATA        = '@(data)'
    PATTERN_COMMAND     = '@(command)'
    PATTERN_ACTION      = '@(action)'
    
    #Executer une action de type système, programme, script etc
    class Execute < Action
      
      attr_accessor :command
      
      #Constructeur
      def initialize(command)
        #Vérification de la validité de command
        raise ArgumentError, "#{command.class} invalide, String requis", caller unless command.is_a? String 
        
        @command = command
      end
      
      # Executer l'action
      def run(tag)
        #Remplacer les patterns par les valeurs du tag responsable de l'action
        command = @command.gsub(PATTERN_ID,tag.id).gsub(PATTERN_DATA,tag.data).gsub(PATTERN_COMMAND,tag.command).gsub(PATTERN_ACTION,tag.action)
        raise ActionError.new("Impossible d'executer la commande \"#{command}\", commande invalide.") unless system(command)
      end
      
      #Redéfinission de la représentation String
      def to_s
        return "( #{@command} )"
      end
    end
    
    #Executer une action existante, lien symbolique
    class RaiseAction < Action
      
      attr_accessor :actionToRaise
      
      def initialize(actionToRaise)  
        #Vérification de la validité de action_to_raise
        raise ArgumentError, "#{actionToRaise.class} invalide, Action requis", caller unless actionToRaise.is_a? Action 
    
        @actionToRaise = actionToRaise  
      end
    
      # Executer l'action
      def run(tag)
        begin
          @actionToRaise.run(tag)
        rescue
          raise ActionError.new("Impossible d'exécuter l'action, car action invalide")
        end
      end
      
      #Redéfinission de la représentation String
      def to_s
        return "( #{@actionToRaise.to_s} )"
      end
    end
    
    #Executer une action HTTP sur un URL
    class HTTP_URL < Action
      
      attr_accessor :url, :method, :params, :headers, :data
    
      #Constantes des méthodes HTTP
      HTTP_METHODS = {  :GET    => 'GET', 
                        :HEAD   => 'HEAD', 
                        :POST   => 'POST', 
                        :PUT    => 'PUT', 
                        :DELETE => 'DELETE'
                    }
      
      DEFAULT_PORT = 80
      
      #Constructeur
      def initialize(url, method = :GET, params = {}, headers = {}, data = "")
        
        #Verification des types de données
        raise ArgumentError, "method #{method} inconnu", caller unless HTTP_METHODS.has_key? method
        raise ArgumentError, "params #{params.class} invalide, Hash requis", caller unless params.is_a? Hash       
        raise ArgumentError, "headers #{headers.class} invalide, Hash requis", caller unless headers.is_a? Hash       
        raise ArgumentError, "data #{data.class} invalide, String requis", caller unless data.is_a? String 
        
        if url.is_a? String then
          #tentative de parsage
          begin
            url = URI.parse(url)
          rescue
            raise ArgumentError, "url #{url} mal formé"
          end
        else
          raise ArgumentError, "url #{url.class} invalide, URI requis", caller unless url.is_a? URI
        end
        
  
        #Affectation des valeurs passées au constructeur avec application des valeurs par défaut        
        @url            = url
        @url.port       = DEFAULT_PORT if url.port.nil?
        @method         = method
        @params         = params
        @headers        = headers
        @data           = data
      end
      
      # Executer l'action
      def run(tag)
        begin
          if @url.request_uri.empty? then
            @url.request_uri = "/"
          end
          
          #Remplacer les patterns par les valeurs du tag responsable de l'action
          url_request_uri	= @url.request_uri.gsub(PATTERN_ID,tag.id).gsub(PATTERN_DATA,tag.data).gsub(PATTERN_COMMAND,tag.command).gsub(PATTERN_ACTION,tag.action)
          data		        = @data.gsub(PATTERN_ID,tag.id).gsub(PATTERN_DATA,tag.data).gsub(PATTERN_COMMAND,tag.command).gsub(PATTERN_ACTION,tag.action)
                  
          case(@method) 
            when :GET then
              request = Net::HTTP::Get.new(url_request_uri, @headers)
              response = Net::HTTP.new(@url.host, @url.port).start { |http| http.request(request) }
              return response.body
              
            when :HEAD then
              request = Net::HTTP::Head.new(url_request_uri, @headers)
              response = Net::HTTP.new(@url.host, @url.port).start { |http| http.request(request) }
              return response.header.to_hash
              
            when :POST then
              request = Net::HTTP::Post.new(url_request_uri, @headers)
              request.set_form_data(@params)
              request.body=data
              response = Net::HTTP.new(@url.host, @url.port).start { |http| http.request(request) }
              return response.body
              
            when :PUT then
              request = Net::HTTP::Put.new(url_request_uri, @headers)
              request.set_form_data(@params)
              request.body=data
              response = Net::HTTP.new(@url.host, @url.port).start { |http| http.request(request) }
              return response.body
              
            when :DELETE then
              request 	= Net::HTTP::Delete.new(url_request_uri, @headers)
              response 	= Net::HTTP.new(@url.host, @url.port).start { |http| http.request(request) }
              return response.body
              
            else
              raise ActionError.new("La méthode (#{method}) demandée n'as pas encore été implémentée")
          end
        rescue => error
          raise ActionError.new("L'action à échoué, URL invalide ou aucune connexion réseau disponnible. \n Information sur l'erreur: [#{error}]")
        end
      end
    end

    #Constructeur
    def initialize
      raise ActionError.new("Classe Abstraite impossible d'instancier.")
    end
    
    #Exécuter l'action
    def run(tag)
      raise ActionError.new("Impossible d'exécuter car aucune méthode run(tag) définie.")
    end
    
    #Redéfinission de la représentation String
    def to_s
      return "( #{@method.to_s} -> #{@url.to_s} )"
    end
  end
end