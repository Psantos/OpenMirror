#!/usr/bin/env ruby
# Script de test pour la classe WebApp
#
# Author::      dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright::   Copyright (c) 2010 - dos Santos Pedro.
# Date::        30 juin 2010
# Version::     1.0
# Modifications:: 
# :title:       WebAppTest.rb
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

__GUIPATH__ = File.join($ROOTPATH, "gui","")

require __GUIPATH__ + 'WebAppGui.rb'

include OpenMirror

app = Qt::Application.new(ARGV)
window = WebAppGui.new(app)
window.show
app.exec
