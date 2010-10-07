# Classe permettant de modeliser un évenement basé sur une lecture du mirror
# 
# Author::    	dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright:: 	Copyright (c) 2010 - dos Santos Pedro.
# Date:: 	14 avril 2010 
# Version::	1.0
# :title: 	Event.rb
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

require 'yaml'

module OpenMirror      
  class Event

    __PATH__ = File.join(File.dirname(__FILE__),"")
    
    #Liste des events enregistrés
    @@evenList = Array.new();
    
    attr_accessor :name, :matches, :actions
    
    #Classe modélisant une correspondance entre un événement et un tag, pour lancer une action.
    class Match
      
      attr_accessor :field, :value
      
      #Teste si ce événement correspond au tag passé en paramètre.
      #Retourne true si le match correspond au tag
      def match(tag)
        case(field)
          when :id 	then
            return areEqual?(@value, tag.id)
          
          when :data 	then
            return areEqual?(@value, tag.data)
            
          when :command 	then
            return areEqual?(@value, tag.command)
            
          when :action 	then
            return areEqual?(@value, tag.action)
          
          #nom de field inconnu, évaluation fausse
          else
            return false
        end
      end
      
      #Constructeur
      #Construit un motif de comparaison sur la base d'un symbole et d'une valeur.
      #Le symbole correspond au champ à tester.
      def initialize(field, value)
        
        #Vérification de la validité du paramètre field
        raise ArgumentError, "#{field.class} invalide, Symbol requis", 	 caller unless field.is_a? Symbol
      
        @field = field
        @value = value
      end
      
      private
      #Méthode de comparaison générique, gérant plusieurs types
      def areEqual?(reference, value)
              
        case(reference)
          when String:
            return (reference === value.to_s)
            
          when Regexp:
            return (reference.match(value) != nil)
            
          when Fixnum:
            return (reference === value.to_i)
            
          when Symbol:
            return (reference === value.to_sym)   
            
          #classe inconnue, évaluation fausse
          else
            return false
        end
      end
      
    end
    
    #Teste si un événement configuré correspond au tag passé en paramètre.
    #Execute l'action correspondante à l'évemenent
    #Si parallel est mis à false, les actions seront lancés séquentiellement, dans le cas contraire elles seront lancées en parralèle.
    def self.match(tag, parallel=true)
      raise ArgumentError, "#{tag.class} invalide, Tag requis", caller unless tag.is_a? Tag 
      @@evenList.each do |event|
        
        matching = true
        event.matches.each do |match|
          matching = false unless match.match(tag)
        end

        #Le match est true si tous les matchs correspondent.
        if matching then
          event.actions.each do |action|
            thread = Thread.new {action.run(tag)}
            
            #Exécution séquentielle si false
            thread.join unless parallel
          end
          # Une fois toutes les actions executée, annuler la comparaison des autres matchs
          return event.name
        end
      end
          
      return nil
    end
    
    #Charge la liste d'évenements d'après une configuration YAML
    def self.setConfiguration(configurationFile)
      @@evenList = YAML.load(open(configurationFile))
    end
    
    #Constructeur
    #Construit un événement basé sur une liste d'événement à tester et d'une liste d'actions à exécuter en cas de comparaison positive.
    def initialize(name, matchesList, actionsList)  

      #Vérification de la validité des paramètres
      raise ArgumentError, "#{name.class} invalide, String requis", 	   caller unless name.is_a? String 
      raise ArgumentError, "#{matchesList.class} invalide, Array requis",  caller unless matchesList.is_a? Array 
      raise ArgumentError, "#{actionsList.class} invalide, Array requis",  caller unless actionsList.is_a? Array 

      #Vérification de la validité des éléments internes aux parametres de liste
      matchesList.each do |element|
        raise ArgumentError, "#{element.class} invalide, Event::Match requis", caller unless element.is_a? Event::Match 
      end
    
      actionsList.each do |element|
        raise ArgumentError, "#{element.class} invalide, Action requis", caller unless element.is_a? Action 
      end  
          
      @name     = name
      @matches  = matchesList
      @actions  = actionsList
    end
    
    #Ajouter un event à la liste des events configurés
    def self.addEvent(event)
      raise ArgumentError, "#{event.class} invalide, Event requis", caller unless name.is_a? Event 
      @@evenList << event
    end
  end
end