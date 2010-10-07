#!/usr/bin/env ruby

# Script de test pour la classe Action (en se basant sur les classes Mirror et Tag)
# 
# Author::    	dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright:: 	Copyright (c) 2010 - dos Santos Pedro.
# Date:: 	1er avril 2010
# Version::	1.0
# :title: 	ActionTest.rb
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
require 'pp'

include OpenMirror

puts
puts "-------------------------------------------------------------------------"
puts " * Scénario :                                                            "
puts "     Suivant le lapin qui est posé executer une action différente        "
puts "       - Lapin bleu aux oreilles noires    : ==> www.perdu.com           "
puts "       - Lapin noir aux oreilles jaunes    : ==> eject CDROM             "
puts "       - Lapin vert aux oreilles noires    : ==> pareil que l-noir/jaune "
puts "       - Lapin fuschia aux oreilles noires : ==> www.google.ch (HEAD)    "
puts "                                                                         "
puts "     Retournez le mirror pour arreter le scénario de test                "
puts "                                                                         "
puts "-------------------------------------------------------------------------"
  
  #Déclaration des actions
  action_lapin_bleu_noir	= Action::HTTP_URL.new(URI.parse("http://www.perdu.com"))
  action_lapin_noir_jaune	= Action::Execute.new("eject")
  action_lapin_vert_noir	= Action::RaiseAction.new(action_lapin_noir_jaune)
  action_lapin_fuschia_noir	= Action::HTTP_URL.new(URI.parse("http://www.google.ch"), :HEAD)

  mirror = Mirror.mirrors.first
  mirror.open
  
  begin
        tag = mirror.read
	
	if(tag.command == Tag::COMMAND[:COMMAND_READ]) and (tag.action == Tag::ACTION[:ACTION_TAG_ON]) then
	  #identification de l'id
	  case (tag.id)
	    #bleu-noire	: 000008d0021a053b4d4c11
	    when '000008d0021a053b4d4c11'
	      puts "lapin bleu aux oreilles noires"
	      pp action_lapin_bleu_noir.run(tag)
	      
	    #noir-jaune	: A000008d0021a053b472143
	    when '000008d0021a053b472143'
	      puts "lapin noir aux oreilles jaunes"
	      action_lapin_noir_jaune.run(tag)
	      
	    #vert-noir	: 000008d0021a0353191b70
	    when '000008d0021a0353191b70'
	      puts "lapin vert aux oreilles noires"
	      action_lapin_vert_noir.run(tag)
	      
	    #fuschia-noir	: 000008d0021a0353140716
	    when '000008d0021a0353140716'
	      puts "lapin fuschia aux oreilles noires"
	      pp action_lapin_fuschia_noir.run(tag)
	  
	    else	
	      puts "Ce lapin est inconnu, son id est: #{tag.id}"
	  end
	end
	
	
	
  end until tag.command == Tag::COMMAND[:COMMAND_ONOFF]  
 