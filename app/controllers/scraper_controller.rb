class ScraperController < ApplicationController

  require 'open-uri'
  require 'net/http'

  def index
    # Url
    url = "https://echanges.dila.gouv.fr/OPENDATA/BODACC/#{Time.now.year}/"

    # Nokogiri for xml scraping, Mechanize for file download
    # page = Nokogiri::HTML(open(url))
    # agent = Mechanize.new

    # # Download every new files
    # puts "Downloading and decompresing files...".light_blue
    # page.search('//tr').each do |line|
    #   next if line.search('td/text()')[4].to_s.blank?
    #   date = line.search('td/text()')[4].to_s.strip
    #   file = line.search('td > a/text()').to_s.strip
    #
    #   # Init path depending on the file
    #   path = get_path(file)
    #
    #   # Downloading them if not already
    #   if date.to_time > Time.now - 1.day
    #     agent.pluggable_parser.default = Mechanize::Download
    #     agent.get(url + file).save(path)
    #   end
    #
    #   #Untar every files and remove all .taz file
    #   system('tar -xvf '+path+ ' -C '+path.gsub(file, "")+ '; rm '+path)
    # end


    # Downloading completed
    puts "Done".green
    puts "Inserting into database...".light_blue

    # BILAN (BODACC C)
    # i = 0
    # Dir.glob('tmp/xml/BILAN/*') do |file|
    #   # system('tar -xvf '+file+ ' -C tmp/xml/BILAN/')
    #
    #   xml = Nokogiri::XML(open(file))
    #   xml.xpath('//avis').each do |avis|
    #     Bilan.create( \
    #       nojo: avis.search('nojo').text,
    #       type_annonce: avis.search('typeAnnonce').children,
    #       numero_annonce: avis.search('numeroAnnonce').text,
    #       numero_departement: avis.search('numeroDepartement').text,
    #       tribunal: avis.search('tribunal').text,
    #       siren: avis.search('numeroIdentificationRCS').text,
    #       code_rcs: avis.search('codeRCS').text,
    #       nom_greffe_immat: avis.search('nomGreffeImmat').text,
    #       denomination: avis.search('denomination').text,
    #       sigle: avis.search('sigle').text,
    #       forme_juridique: avis.search('formeJuridique').text,
    #       numero_voie: avis.search('numeroVoie').text,
    #       type_voie: avis.search('typeVoie').text,
    #       nom_voie: avis.search('nomVoie').text,
    #       compl_geographique: avis.search('complGeographique').text,
    #       code_postal: avis.search('codePostal').text,
    #       ville: avis.search('ville').text,
    #       date_cloture: avis.search('dateCloture').text,
    #       type_depot: avis.search('typeDepot').text,
    #       descriptif: avis.search('descriptif').text,
    #       nom_publication_ap: avis.search('nomPublication').text,
    #       numero_parution_ap: avis.search('numeroPublication').text,
    #       date_parution_ap: avis.search('dateParution').text,
    #       numero_annonce_ap: avis.search('parutionAvisPrecedent/numeroAnnonce').text,
    #       file: file.split('/').last,
    #       type_bodacc: "BODACC-C",
    #       annee_parution: Time.now.year - 9
    #     )
    #     i = i + 1
    #   end
    #   system("rm "+file)
    #   next if file == '.' or file == '..'
    #   puts i.to_s + " new bilan"
    # end
    # system('rm tmp/xml/BILAN/*.taz*')

    # PCL (BODACC A)
    # i = 0
    # Dir.glob('tmp/xml/PCL/*') do |file|
    #   xml = Nokogiri::XML(open(file))
    #   xml.xpath('//annonce').each do |annonce|
    #     Pcl.create( \
    #       nojo: annonce.search('nojo').text,
    #       type_annonce: annonce.search('typeAnnonce').children,
    #       numero_annonce: annonce.search('numeroAnnonce').text,
    #       numero_departement: annonce.search('numeroDepartement').text,
    #       tribunal: annonce.search('tribunal').text,
    #       identifiant_client: annonce.search('identifiantClient').text,
    #       siren: annonce.search('numeroIdentificationRCS').text,
    #       code_rcs: annonce.search('codeRCS').text,
    #       nom_greffe_immat: annonce.search('nomGreffeImmat').text,
    #       denomination: annonce.search('denomination').text,
    #       sigle: annonce.search('sigle').text,
    #       forme_juridique: annonce.search('formeJuridique').text,
    #       numero_voie: annonce.search('numeroVoie').text,
    #       type_voie: annonce.search('typeVoie').text,
    #       nom_voie: annonce.search('nomVoie').text,
    #       compl_geographique: annonce.search('complGeographique').text,
    #       code_postal: annonce.search('codePostal').text,
    #       ville: annonce.search('ville').text,
    #       famille: annonce.search('famille').text,
    #       nature: annonce.search('nature').text,
    #       date_jugement: annonce.search('date').text,
    #       compl_jugement: annonce.search('complementJugement').text,
    #       nom_publication_ap: annonce.search('nomPublication').text,
    #       numero_parution_ap: annonce.search('numeroPublication').text,
    #       date_parution_ap: annonce.search('dateParution').text,
    #       numero_annonce_ap: annonce.search('parutionAvisPrecedent/numeroAnnonce').text,
    #       file: file.split('/').last,
    #       type_bodacc: "BODACC-A",
    #       annee_parution: Time.now.year - 9
    #     )
    #     i = i + 1
    #   end
    #   system("rm "+file)
    #   next if file == '.' or file == '..'
    #   puts i.to_s + " pcl"
    # end

    # RCS-B Modifications (BODACC B)
    i = 0
    Dir.glob('tmp/xml/RCS-B/*') do |file|
      xml = Nokogiri::XML(open(file))
      xml.xpath('//avis').each do |annonce|
        if !annonce.search('modificationsGenerales').blank?
          Modification.create( \
            nojo: annonce.search('nojo').text,
            type_annonce: annonce.search('typeAnnonce').children,
            numero_annonce: annonce.search('numeroAnnonce').text,
            numero_departement: annonce.search('numeroDepartement').text,
            tribunal: annonce.search('tribunal').text,
            siren: annonce.search('numeroIdentificationRCS').text,
            code_rcs: annonce.search('codeRCS').text,
            nom_greffe_immat: annonce.search('nomGreffeImmat').text,
            denomination: annonce.search('denomination').text,
            sigle: annonce.search('sigle').text,
            forme_juridique: annonce.search('formeJuridique').text,
            date_commencement_activite: annonce.search('dateCommencementActivite').text,
            date_effet: annonce.search('dateEffet').text,
            descriptif: annonce.search('descriptif').text,
            denomination_pepm: annonce.search('modificationsGenerales/precedentExploitantPM/denomination').text,
            siren_pepm: annonce.search('modificationsGenerales/precedentExploitantPM/numeroImmatriculation/numeroIdentification').text,
            nature_pepp: annonce.search('modificationsGenerales/precedentExploitantPP/nature').text,
            nom_pepp: annonce.search('modificationsGenerales/precedentExploitantPP/nom').text,
            prenom_pepp: annonce.search('modificationsGenerales/precedentExploitantPP/prenom').text,
            nom_usage_pepp: annonce.search('modificationsGenerales/precedentExploitantPP/nomUsage').text,
            siren_pepp: annonce.search('modificationsGenerales/precedentExploitantPP/numeroImmatriculation/numeroIdentification').text,
            nom_publication_ap: annonce.search('nomPublication').text,
            numero_parution_ap: annonce.search('numeroPublication').text,
            date_parution_ap: annonce.search('dateParution').text,
            numero_annonce_ap: annonce.search('parutionAvisPrecedent/numeroAnnonce').text,
            file: file.split('/').last,
            type_bodacc: "BODACC-B",
            annee_parution: Time.now.year
          )
        else
          puts "radiation"
          Radiation.create( \
            nojo: annonce.search('nojo').text,
            type_annonce: annonce.search('typeAnnonce').children,
            numero_annonce: annonce.search('numeroAnnonce').text,
            numero_departement: annonce.search('numeroDepartement').text,
            tribunal: annonce.search('tribunal').text,
            siren: annonce.search('numeroIdentificationRCS').text,
            code_rcs: annonce.search('codeRCS').text,
            nom_greffe_immat: annonce.search('nomGreffeImmat').text,
            denomination: annonce.search('denomination').text,
            sigle: annonce.search('sigle').text,
            forme_juridique: annonce.search('formeJuridique').text,
            type_voie: annonce.search('typeVoie').text,
            numero_voie: annonce.search('numeroVoie').text,
            nom_voie: annonce.search('nomVoie').text,
            code_postal: annonce.search('codePostal').text,
            ville: annonce.search('ville').text,
            radiation_pm: annonce.search('radiationPM').text,
            date_cessation_activite_pp: annonce.search('dateCessationActivitePP').text,
            commentaire: annonce.search('commentaire').text,
            nom_publication_ap: annonce.search('nomPublication').text,
            numero_parution_ap: annonce.search('numeroPublication').text,
            date_parution_ap: annonce.search('dateParution').text,
            numero_annonce_ap: annonce.search('parutionAvisPrecedent/numeroAnnonce').text,
            file: file.split('/').last,
            type_bodacc: "BODACC-B",
            annee_parution: Time.now.year
          )
        end
        i = i + 1
      end
      system("rm "+file)
      next if file == '.' or file == '..'
      puts i.to_s + " new modifications"
    end

    # RCS-A (BODACC A)
    # i = 0
    # Dir.glob('tmp/xml/RCS-A/*') do |file|
    #   xml = Nokogiri::XML(open(file))
    #   xml.xpath('//avis').each do |annonce|
    #     if !annonce.search('categorieVente').blank?
    #       immat = annonce.search('categorieVente').text
    #       categorie = "Vente"
    #     elsif !annonce.search('categorieCreation').blank?
    #       immat = annonce.search('categorieCreation').text
    #       categorie = "Creation"
    #     else
    #       immat = annonce.search('immatriculation').text
    #       categorie = "Immatriculation"
    #     end
    #       Immatriculation.create( \
    #         nojo: annonce.search('nojo').text,
    #         type_annonce: annonce.search('typeAnnonce').children,
    #         numero_annonce: annonce.search('numeroAnnonce').text,
    #         numero_departement: annonce.search('numeroDepartement').text,
    #         tribunal: annonce.search('tribunal').text,
    #         siren: annonce.search('numeroIdentification').text,
    #         code_rcs: annonce.search('codeRCS').text,
    #         nom_greffe_immat: annonce.search('nomGreffeImmat').text,
    #         denomination: annonce.search('denomination').text,
    #         administration: annonce.search('administration').text,
    #         montant_capital: annonce.search('montantCapital').text,
    #         devise: annonce.search('devise').text,
    #         forme_juridique: annonce.search('formeJuridique').text,
    #         type_voie: annonce.search('typeVoie').text,
    #         numero_voie: annonce.search('numeroVoie').text,
    #         nom_voie: annonce.search('nomVoie').text,
    #         code_postal: annonce.search('codePostal').text,
    #         ville: annonce.search('ville').text,
    #         origine_fonds: annonce.search('origineFonds').text,
    #         qualite_etablissement: annonce.search('qualiteEtablissement').text,
    #         activite: annonce.search('activite').text,
    #         date_commencement_activite: annonce.search('dateCommencementActivite').text,
    #         date_immatriculation: annonce.search('dateImmatriculation').text,
    #         descriptif: annonce.search('descriptif').text,
    #         date_effet: annonce.search('dateEffet').text,
    #         journal: annonce.search('journal').text,
    #         opposition: annonce.search('opposition').text,
    #         declaration_creance: annonce.search('declarationCreance').text,
    #         categorie: categorie,
    #         immatriculation: immat,
    #         nom_publication_ap: annonce.search('nomPublication').text,
    #         numero_parution_ap: annonce.search('numeroPublication').text,
    #         date_parution_ap: annonce.search('dateParution').text,
    #         numero_annonce_ap: annonce.search('parutionAvisPrecedent/numeroAnnonce').text,
    #         file: file.split('/').last,
    #         type_bodacc: "BODACC-A",
    #         annee_parution: Time.now.year
    #       )
    #       i = i + 1
    #   end
    #   system("rm " +file)
    #   next if file == '.' or file == '..'
    #   puts i.to_s + " new immatriculations"
    # end

    puts "Boaper did his job !".green
    puts "Bye !"

  end

  private

  def get_path(file)
    if file.to_s.include? 'BILAN'
      path = "tmp/xml/BILAN/" + file
    elsif file.to_s.include? 'RCS-A'
      path = "tmp/xml/RCS-A/" + file
    elsif file.to_s.include? 'RCS-B'
      path = "tmp/xml/RCS-B/" + file
    elsif file.to_s.include? 'PCL'
      path = "tmp/xml/PCL/" + file
    end
    return path
  end

end
