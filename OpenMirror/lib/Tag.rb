# Classe permettant de modeliser une lecture du mirror
# 
# Author::    	dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright:: 	Copyright (c) 2010 - dos Santos Pedro.
# Date:: 	24 mars 2010
# Version::	1.2
# :title: 	Tag.rb
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

module OpenMirror

  class Tag
    __PATH__ = File.join(File.dirname(__FILE__),"")
    
    #Constantes des commandes
    COMMAND = {
                :COMMAND_NULL           => '00',
                :COMMAND_ONOFF          => '01',
                :COMMAND_READ           => '02'
              }
    
    #Constantes des actions
    ACTION = {
                :ACTION_NULL            => '00',
                :ACTION_TAG_ON          => '01',
                :ACTION_TAG_OFF         => '02',
                :ACTION_MIRROR_ON       => '04',
                :ACTION_MIRROR_OFF      => '05'
            }
      
    attr_reader :command, :action, :id, :data, :time
    
    #Constructeur
    def initialize(command, action, id, data)
      
      #Vérification de la validité de command
      if(command.is_a? Symbol) then
        raise ArgumentError, "Commande #{command} inconnue", caller unless COMMAND.has_key? command
      else
        raise ArgumentError, "Commande #{command} inconnue", caller unless COMMAND.has_value? command
      end
      
      #Vérification de la validité de actions
      if(command.is_a? Symbol) then
        raise ArgumentError, "Action #{action} inconnue", caller unless ACTION.has_key? action
      else
        raise ArgumentError, "Action #{action} inconnue", caller unless ACTION.has_value? action
      end
          
      #Vérification de la validité de l'id
      raise ArgumentError, "#{id.class} invalide, String requis", caller unless id.is_a? String 
          
      #Vérification de la validité de l'data
      raise ArgumentError, "#{data.class}  invalide, String requis", caller unless data.is_a? String

      @command  = command
      @action   = action
      @id       = id
      @data     = data
      @time     = Time.now
    end
  end
end