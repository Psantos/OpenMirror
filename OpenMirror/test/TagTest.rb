#!/usr/bin/env ruby
# Script de test pour la classe Action (en se basant sur les classes Mirror et Tag)
# 
# Author::    	dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright:: 	Copyright (c) 2010 - dos Santos Pedro.
# Date:: 	1 avril 2010
# Version::	1.0
# :title: 	TagTest.rb
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

__LIBPATH__ = File.join($ROOTPATH, "lib","")

require __LIBPATH__ + 'Mirror.rb'
require __LIBPATH__ + 'Tag.rb'
require __LIBPATH__ + 'Action.rb'

include OpenMirror

puts
puts "--------------------------------------------------------------------------------"
puts " * Scénario :                                                                   "
puts "     Manipulez votre mirror avec vos tag, vos actions s'afficherons à l'écran.  "
puts "--------------------------------------------------------------------------------"
  
  mirror = OpenMirror::Mirror.mirrors.first
  mirror.open
  
  #Boucle infinie
  begin
    tag = mirror.read
    
    #case sur la commande
    case (tag.command)
      when Tag::COMMAND[:COMMAND_NULL]
	puts "Commande : Nulle"
      when Tag::COMMAND[:COMMAND_ONOFF]
	puts "Commande : Mirror On/Off"
      when Tag::COMMAND[:COMMAND_READ]
	puts "Commande : Lecture d'un tag"	
    end	
    
    case (tag.action)
      when Tag::ACTION[:ACTION_NULL]
	puts "  --> Action : Nulle"
      when Tag::ACTION[:ACTION_TAG_ON]
	puts "  --> Action : Tag posé sur le mirror"
      when Tag::ACTION[:ACTION_TAG_OFF]
	puts "  --> Action : Tag retiré du mirror"	    
      when Tag::ACTION[:ACTION_MIRROR_ON]
	puts "  --> Action : Mirror activé"	    
      when Tag::ACTION[:ACTION_MIRROR_OFF]
	puts "  --> Action : Mirror désactivé"	    
    end
    
    puts ""
    
  end while true