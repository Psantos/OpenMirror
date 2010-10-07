# Classe permettant de communiquer avec le mirror par usb
# 
# Author::    	dos Santos Pedro  (pedro.d2.santos@gmail.com)
# Copyright:: 	Copyright (c) 2010 - dos Santos Pedro.
# Date:: 	24 mars 2010
# Version::	1.2
# :title: 	Mirror.rb
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

require 'usb'

module OpenMirror

  class Mirror
    __PATH__ = File.join(File.dirname(__FILE__),"")
    
    # Classe d'exceptions interne
    class MirrorError < Exception
    end      
    
    # Constantes d'identification du mirror
    ID_VENDOR   = '1DA8'
    ID_PRODUCT  = '1301'
    
    # Constantes d'accès au périphérique
    RETRY_TIME  = 1
    TIME_OUT    = 5000
    MAX_RETRIES = 5
    
    # Constantes d'interpretation des bytes lus
    RANGE_COMMAND       = 0..0
    RANGE_ACTION        = 1..1
    RANGE_ID            = 2..12
    RANGE_DATA          = 13..31
      
    #Pattern OS
    LINUX_OS_PATTERN    = "linux"
    WINDOWS_OS_PATTERN  = "mswin"
    OSX_OS_PATTERN      = "darwin"
    
    #Endpoints
    LINUX_ENDPOINT_POSITION     = 1
    WINDOWS_ENDPOINT_POSITION   = 0
    OSX_ENDPOINT_POSITION       = 1
    DEFAULT_ENDPOINT_POSITION   = 0
    
    # Variables de classe
    @@listMirrors = []
    @@NULL_DATA_PACK = ([0]*64).pack('C*')
    
    #Retourne la liste des mirrors connectés
    def self.mirrors
      if @@listMirrors.empty? then
        findMirrors
      end
      
      return @@listMirrors
    end
    
    
    # Demander l'ouverture du mirror 
    def open
      if @opened then
        return false
      else
        # Réclamer l'interface
        claimInterface
        @opened = true
        return true
      end
    end
    
    
    # Demander la fermeture du mirror
    def close
      if @opened then
        release
        @opened = false
        return true
      else
        return false
      end
    end
      
    
    # Récupérer le nom du bus du mirrors
    def busName
      @device.bus.dirname.to_s
    end
    
    
    # Récuperer le nom du périphérique
    def peripheralName
      @device.filename.to_s
    end
    
    
    # Effectuer une lecture bloquante sur le mirror
    def read
      if @opened then  
        #Déclaration d'un tampon vide et d'une référence
        dataPack = ([0]*64).pack('C*')

        #Lire le mirror tant que la lecture n'est pas vide
        begin
          @handle.usb_bulk_read(@endpoint.bEndpointAddress,dataPack,TIME_OUT)
        end while dataPack === @@NULL_DATA_PACK   
        
        #Creer un nouvel objet Tag sur la base de la lecture
        dataArray = dataPack.unpack('H2'*32)      
        tagRead = Tag.new(dataArray[RANGE_COMMAND].to_s,dataArray[RANGE_ACTION].to_s,dataArray[RANGE_ID].to_s,dataArray[RANGE_DATA].to_s)
      
        return tagRead
      else
        raise MirrorError.new("Erreur le mirror n'est pas ouvert")
      end
    end
      
    # Effectuer une lecture non bloquante sur le mirror
    def simpleRead
      if @opened then  
        #Déclaration d'un tampon vide et d'une référence
        dataPack = ([0]*64).pack('C*')

        #Lire le mirror
        @handle.usb_bulk_read(@endpoint.bEndpointAddress,dataPack,TIME_OUT)
        
        #Creer un nouvel objet Tag sur la base de la lecture
        dataArray = dataPack.unpack('H2'*32)      
        tagRead = Tag.new(dataArray[RANGE_COMMAND].to_s,dataArray[RANGE_ACTION].to_s,dataArray[RANGE_ID].to_s,dataArray[RANGE_DATA].to_s)
        
      else
        raise MirrorError.new("Erreur le mirror n'est pas ouvert")
      end
    end
    
    
  private
    #Constructeur privé
    def initialize(device)
      #Vefirication de la validite de device
      raise ArgumentError, "#{device.class} invalide, USB::Device requis", caller unless device.is_a? USB::Device 
      
      #Variables relatives au mirror
      @device           = device
      @handle           = @device.open
      @configuration    = @device.configurations.first
      @interface        = @configuration.interfaces.first
      
      #En fonction de la plateforme appliquer le bon endpoint      
      if(PLATFORM.match(LINUX_OS_PATTERN)) then
        @endpoint = @interface.settings.first.endpoints[LINUX_ENDPOINT_POSITION]
        
      elsif(PLATFORM.match(WINDOWS_OS_PATTERN))
        @endpoint = @interface.settings.first.endpoints[WINDOWS_ENDPOINT_POSITION]
        
      elsif(PLATFORM.match(OSX_OS_PATTERN))
        @endpoint = @interface.settings.first.endpoints[OSX_ENDPOINT_POSITION]
          
      else
        @endpoint = @interface.settings.first.endpoints[DEFAULT_ENDPOINT_POSITION]
        
      end
      
      #Variables d'état
      @opened  = false
      @claimed = false
    end

    
    # Recherche les mirrors connectés et initialise la liste interne.
    def self.findMirrors	
      # Vider la liste courrante
      @@listMirrors = []
      
      # Liste des mirrors connectés à l'ordinateur
      devices = []
      USB.devices.each do |usbDevice|
        #Identifier les produits de violet-Mindscape
        if (usbDevice.idVendor.to_s(16).upcase === ID_VENDOR) then
          #Identifier les mirrors
          if (usbDevice.idProduct.to_s(16).upcase === ID_PRODUCT) then
            @@listMirrors << Mirror.new(usbDevice)
          end
        end
      end

      # Si aucune mirror n'a été trouvé lever une exceptions
      raise MirrorError.new("Erreur aucun mirror détecté") unless @@listMirrors.size > 0    
      
      return nil
    end
    
    #Réclamer le périphérique
    def claimInterface
      retries = MAX_RETRIES
      
      begin
        #Configuration du périphérique      
        @handle.set_configuration(@configuration.bConfigurationValue)
    
        #Réclamer le périphérique
        codeErreur = @handle.usb_claim_interface(@interface.settings.first.bInterfaceNumber.to_i)  
        raise MirrorError.new()  unless codeErreur.nil?
      rescue
        
        #Si impossible d'obtenir la ressource, et que le système est Linux, détacher le périphérique du kernel
        #En fonction de la plateforme appliquer le bon endpoint
        if(PLATFORM.match("linux")) then
          @handle.usb_detach_kernel_driver_np(@interface.settings.first.bInterfaceNumber.to_i,0)
        end  
        
        #En cas d'erreur faire une autre tentative avec un délai de RETRY_TIME
        sleep RETRY_TIME

        if retries == 0 then
          # Nombre d'essais max attein, => lever une exception pour signaler le probleme
          raise MirrorError.new("Erreur, impossible d'obtenir l'exclusivité sur le mirror") unless codeErreur.nil?
        else
          retries -= 1
          retry
        end
      end
      return nil
    end
      
    
    #Relacher le périphérique
    def release
      @handle.usb_release_interface(@interface.settings.first.bInterfaceNumber.to_i)
      return nil
    end  
  end
end