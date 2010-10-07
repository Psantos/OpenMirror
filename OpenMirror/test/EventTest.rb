#!/usr/bin/env ruby
# Script de test pour la classe Event (en se basant sur les classes Tag et Action, Mirror.rb)
# 
# Author::    	dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright:: 	Copyright (c) 2010 - dos Santos Pedro.
# Date:: 	14 avril 2010
# Version::	1.0
# :title: 	EventTest.rb
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

__PATH__ = File.join(File.dirname(__FILE__),"")
__LIBPATH__ = File.join($ROOTPATH, "lib","")

require __LIBPATH__ + 'Tag.rb'
require __LIBPATH__ + 'Action.rb'
require __LIBPATH__ + 'Event.rb'
require __LIBPATH__ + 'Mirror.rb'

include OpenMirror

EVENT_CONFIG_TEST_FILE = __PATH__ + "EventTest.events"

puts
puts "---------------------------------------------------------------------------------------"
puts " * Scénario :                                                                          "
puts "     Suivant le lapin qui est posé executer une action différente                      "
puts "       - Lapin bleu aux oreilles noires    : ==> www.perdu.com                         "
puts "       - Lapin noir aux oreilles jaunes    : ==> eject CDROM                           "
puts "       - Lapin dont l'id commence par 000008d0021...    : ==> www.google.ch/id (HEAD)  "
puts "                                                                                       "
puts "       - Un lapin connu ajoutera son id dans un fichier Lapins.connus                  "
puts "       - Tous les lapins ajouteraont leurs id dans un fichier Lapins.txt               "
puts "                                                                                       "
puts "     Retournez le mirror pour arreter le scénario de test                              "
puts "                                                                                       "
puts "---------------------------------------------------------------------------------------"
  
  #Les actions sont déclares dans EventTest.events
  
  #Chargement des events
  Event.setConfiguration(EVENT_CONFIG_TEST_FILE)

  mirror = Mirror.mirrors.first
  mirror.open
  
  begin
    tag = mirror.read
    
    puts Event.match(tag)

  end until tag.command == Tag::COMMAND[:COMMAND_ONOFF]  