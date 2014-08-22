#N'utiliser sous aucun pretexte

namespace :console do
        require 'highline/import'
        
	desc "Bidouillage d'urgence : changement d'ip"
	task :ip_change => :environment do
		mac = ask("Adresse mac :")
		new_ip = ask("Nouvelle adresse ip")
                Computer.not_archived.each do |c|
			if(c.mac_address == mac)
				c.ip_address = new_ip
				c.save
			end
                end
		#new_ip = ask("Nouvelle adresse ip") {|q| q.echo=false}
	end

	desc "Recherche d'ip"
        task :ip_lookup => :environment do
                ip = ask("Adresse ip")
                Computer.all.each do |c|
                        if(c.ip_address == ip)
                                puts c.mac_address
                        end
                end
                #new_ip = ask("Nouvelle adresse ip") {|q| q.echo=false}
        end

	desc "Script d'ajout d'une periode gratuite"
	task :add_free_period => :environment do
		admin = nil
		members = 0.to_f
		Admin.all.each do |a|
			if a.username == "igor" then
				admin = a
			end
		end
		puts "admin : " + admin.username

		Adherent.not_archived.each do |a|
			if a.credit != nil then
				members += 1
				p = a.credit.payments.new
				p.comment = "[Script][16082014] période offerte avant l'inté en attendant une gestion plus \"user friendly\" des rupture de connection"
				p.mean = "liquid"
				p.paid_value = 0
				p.value = 14.to_f*Credit::Monthly_cotisation/30
				p.cotisation = Credit::Monthly_cotisation
				p.admin = admin
				puts admin.username + " ajoute " + (14.to_f*Credit::Monthly_cotisation/30).to_s + " à " + a.full_name
				p.save!
			end
		end
		puts "il y a " + members.to_s + " membres"
	end

	desc "Script de suppression de paiement ajoute par script"
	task :del_free_period => :environment do
		Payment.all.each do |p|
			if p.comment.include?("[Script][16082014]") then
				puts "destroyed " + p.value.to_s + " belonging to " + p.adherent.full_name
				p.destroy
			end
		end
	end
end