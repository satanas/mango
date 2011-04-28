class UsuariosController < ApplicationController
    
    def autenticar
      login = params['usuario']['login']
      pwd = params['usuario']['password']
      user = Usuario.autenticar(login, pwd)
      puts "Autenticacion de usuario: #{user.inspect}"
    end
    
end
