#!/usr/bin/env ruby

# Script de test pour la classe Mirror
#
# Author::    	dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright:: 	Copyright (c) 2010 - dos Santos Pedro.
# Date:: 	24 mars 2010
# Version::	1.2
# Modifications:: Adaptation aux modifications sur les classes Mirror, Tag et Action.
# :title: 	MirrorTest.rb
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
require 'pp'

include OpenMirror

def ok
  puts "\t OK"
end

def ko
  puts "\t KO"
  raise RuntimeError, "Une erreur s'est produite, \n Veuillez corriger et relancer le test."
end

puts
puts "-------------------------------"
puts " * Scénario : Appels non permis"
puts "-------------------------------"

  m = Mirror.new(USB.devices.first)

  print " *> test find_mirrors : "
  begin
    m.find_mirrors
  rescue NoMethodError
    ok
  rescue
    ko
  end

  print " *> test claimInterface :"
  begin
    m.claimInterface
  rescue NoMethodError
    ok
  rescue
    ko
  end

  print " *> test release :      "
  begin
    m.release
  rescue NoMethodError
    ok
  rescue
    ko
  end


puts
puts "--------------------------------------------"
puts " * Scénario : Détection des mirrors connecté"
puts "--------------------------------------------"

  print " *> test mirrors :"
  begin
    l = Mirror.mirrors
    ok
    puts "nombre mirrors connectés = [" + l.size.to_s + "]?"
  rescue
    ko
  end

puts
puts "----------------------------------"
puts " * Scénario : Lecture non bloquante"
puts "----------------------------------"
  print " *> test mirrors :"
  begin
    m = Mirror.mirrors.first
    ok
  rescue
    ko
  end

  print " *> test open :   "
  begin
    m.open
    ok
  rescue
    ko
  end

  print " *> test read :   "
  begin
    if m.simpleRead.is_a? Tag then
      ok
    else
      ko
    end
  rescue
    ko
  end

  print " *> test close :"
  begin
    m.close
    ok
  rescue
    ko
  end

puts
puts "---------------------------------------------------------------"
puts " * Scénario : Lecture non bloquante d'un périphérique non ouvert"
puts "---------------------------------------------------------------"
  m = Mirror.mirrors.first

  print " *> test read :"
  begin
    puts m.simpleRead
    ko
  rescue Mirror::MirrorError
    ok
  rescue
    ko
  end

puts
puts "------------------------------"
puts " * Scénario : Lecture bloquante"
puts "------------------------------"
  m = Mirror.mirrors.first
  m.open

  print " *> test mirrors :"
  begin
    m = Mirror.mirrors.first
    ok
  rescue
    ko
  end

  print " *> test open :   "
  begin
    m.open
    ok
  rescue
    ko
  end

  puts "--> Veuillez déposer un lapin sur le mirror..."
  print " *> test read :   "
  begin
    if m.read.is_a? Tag then
      ok
    else
      ko
    end
  rescue
    ko
  end

  puts "--> Veuillez retirer le lapin du mirror..."
  print " *> test read :   "
  begin
    if m.read.is_a? Tag then
      ok
    else
      ko
    end
  rescue
    ko
  end

  print " *> test close :"
  begin
    m.close
    ok
  rescue
    ko
  end

puts
puts "-----------------------------------------------------------"
puts " * Scénario : Lecture bloquante d'un périphérique non ouvert"
puts "-----------------------------------------------------------"
  m = Mirror.mirrors.first
  m.open
  m.close

  print " *> test read :"
  begin
    puts m.read
    ko
  rescue Mirror::MirrorError
    ok
  rescue
    ko
  end

puts
puts "----------------------------------------------------"
puts " * Scénario : fermeture d'un périphérique déja fermé"
puts "----------------------------------------------------"
  m = Mirror.mirrors.first
  m.open
  m.close

  print " *> test close :"
  begin
    puts m.close
    ok
  rescue
    ko
  end
  m.close


puts
puts "-----------------------------------------------------"
puts " * Scénario : Ouverture d'un périphérique déjà ouvert"
puts "-----------------------------------------------------"
  m = Mirror.mirrors.first
  m.open
  print " *> test open :"
  begin
    puts m.open
    puts m.open
    ok
  rescue
    ko
  end
  m.close

puts
puts "-------------------------------------"
puts " * Scénario : Récupérer le nom du bus"
puts "-------------------------------------"
  m = Mirror.mirrors.first
  m.open
  print " *> test busName :"
  begin
    print "(" +  m.busName + ")"
    ok
  rescue
    ko
  end
  m.close

puts
puts "----------------------------------------------"
puts " * Scénario : Récupérer le nom du périphérique"
puts "----------------------------------------------"
  m = Mirror.mirrors.first
  m.open

  print " *> test peripheralName :"
  begin
    print "(" +  m.peripheralName + ")"
    ok
  rescue
    ko
  end
  m.close

puts
puts "--------------------------------"
puts " * Scénario : Lecture d'un lapin"
puts "--------------------------------"
  m = Mirror.mirrors.first
  m.open

  puts "--> Veuillez déposer un lapin sur le mirror..."
  tag1 = m.read
  puts "--> Veuillez retirer le lapin du mirror..."
  tag2 = m.read


  print " *> test command :   "
  begin
    if (tag1.command == Tag::COMMAND[:COMMAND_READ]) and (tag2.command == Tag::COMMAND[:COMMAND_READ]) then
      ok
    else
      ko
    end
  rescue
    ko
  end

  print " *> test action :   "
  begin
    if (tag1.action == Tag::ACTION[:ACTION_TAG_ON]) and (tag2.action == Tag::ACTION[:ACTION_TAG_OFF]) then
      ok
    else
      ko
    end
  rescue
    ko
  end

  print " *> test id :   "
  begin
    if tag1.id == tag2.id then
      ok
    else
      ko
    end
  rescue
    ko
  end

  print " *> test data :   "
  begin
    if tag1.data == tag2.data then
      ok
    else
      ko
    end
  rescue
    ko
  end
  m.close


puts
puts "------------------------------------------"
puts " * Scénario : Lecture d'un event du mirror"
puts "------------------------------------------"
  m = Mirror.mirrors.first
  m.open

  puts "--> Veuillez retourner (à l'envers) le mirror..."
  tag1 = m.read
  puts "--> Veuillez retourner (à l'endroit) le mirror..."
  tag2 = m.read

  print " *> test command :   "
  begin
    if (tag1.command == Tag::COMMAND[:COMMAND_ONOFF]) and (tag2.command == Tag::COMMAND[:COMMAND_ONOFF]) then
      ok
    else
      ko
    end
  rescue
    ko
  end

  print " *> test action :   "

  begin
    if (tag1.action ==  Tag::ACTION[:ACTION_MIRROR_OFF]) and (tag2.action == Tag::ACTION[:ACTION_MIRROR_ON]) then
      ok
    else
      pp tag1
      pp tag2
      ko
    end
  rescue
    ko
  end

  print " *> test id :   "
  begin
    if tag1.id == tag2.id then
      ok
    else
      ko
    end
  rescue
    ko
  end

  print " *> test data :   "
  begin
    if tag1.data == tag2.data then
      ok
    else
      ko
    end
  rescue
    ko
  end
  m.close

puts
puts "---------------------------------------------"
puts " * Tous les tests ont été réussis avec succès"
puts "---------------------------------------------"
puts "
                           oooo$$$$$$$$$$$$oooo
                       oo$$$$$$$$$$$$$$$$$$$$$$$$o
                    oo$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o         o$   $$ o$
    o $ oo        o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o       $$ $$ $$o$
 oo $ $ '$      o$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$o       $$$o$$o$
 '$$$$$$o$     o$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$o    $$$$$$$$
   $$$$$$$    $$$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$$$$$$$$$$$$$$
   $$$$$$$$$$$$$$$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$$$$$$  '''$$$
    '$$$''''$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     '$$$
     $$$   o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     '$$$o
    o$$'   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$       $$$o
    $$$    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$''$$$$$$ooooo$$$$o
   o$$$oooo$$$$$  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  o$$$$$$$$$$$$$$$$$
   $$$$$$$$'$$$$   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     $$$$''''''''''''
            $$$$    '$$$$$$$$$$$$$$$$$$$$$$$$$$$$'      o$$$
             '$$$o     '''$$$$$$$$$$$$$$$$$$'$$'         $$$
               $$$o          '$$''$$$$$$''''           o$$$
                $$$$o                                o$$$'
                 '$$$$o      o$$$$$$o'$$$$o        o$$$$
                   '$$$$$oo     ''$$$$o$$$$$o   o$$$$''
                     ''$$$$$oooo  '$$$o$$$$$$$$$'''
                         ''$$$$$$$oo $$$$$$$$$$
                                 ''''$$$$$$$$$$$
                                     $$$$$$$$$$$$
                                      $$$$$$$$$$'
                                      '$$$''''
"