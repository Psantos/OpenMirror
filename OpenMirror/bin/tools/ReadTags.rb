#! /usr/bin/env ruby
# Outil pour afficher l'identifiant des tags déposés sur le mirror
# 
# Author::    	dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright:: 	Copyright (c) 2010 - dos Santos Pedro.
# Date:: 	25 mars 2010
# Version::	1.0
# :title: 	ReadTags.rb 
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
begin Dir.chdir(File.join(File.dirname(__FILE__), "..", "..")); $ROOTPATH = Dir.pwd; end unless defined? $ROOTPATH

__PATH__ = File.join(File.dirname(__FILE__),"")
__LIBPATH__ = File.join($ROOTPATH,"lib","")

require __LIBPATH__ + 'Mirror.rb'
require __LIBPATH__ + 'Tag.rb'

include OpenMirror

puts "----------------------------------------------------------------------"
puts "      Petit programme de lecture des tags déposés sur le mirror      -"
puts "----------------------------------------------------------------------"
puts ""

  listeMirrors = Mirror.mirrors
  
  #Détéction si plusieurs mirrors sont connectés
  if listeMirrors.size > 1 then
    puts "/!\ Attention plusieurs mirrors ont été détectés sur votre machine"
    puts "Seule le premier sera utilisé pour la lecture."
    puts ""
  end

  mirror = Mirror.mirrors.first
  mirror.open
  
  puts "    Veuillez déposer les lapins dont vous souhaitez connaitre d'ID    "
  puts "----------------------------------------------------------------------"
  
  index = 1

  #Boucle infinie de lecture 
  while true do
    tagRead = mirror.read
    if tagRead.action == Tag::ACTION[:ACTION_TAG_ON] then
      puts "[" + index.to_s + "]\t" + " =>	\t" + tagRead.id.to_s
      index += 1
    end
  end

