module Scraper
  class ModificationAction
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def self.create(annonce, file, date)
      type_annonce =
        annonce.search('typeAnnonce').children.to_s.gsub!(/[^0-9A-Za-z]/, '')
      Modification.create(
        nojo:
          annonce.search('nojo').text,
        type_annonce:
          type_annonce,
        numero_annonce:
          annonce.search('numeroAnnonce').text,
        numero_departement:
          annonce.search('numeroDepartement').text,
        tribunal:
          annonce.search('tribunal').text,
        siren:
          annonce.search('numeroIdentificationRCS').text,
        code_rcs:
          annonce.search('codeRCS').text,
        nom_greffe_immat:
          annonce.search('nomGreffeImmat').text,
        denomination:
          annonce.search('denomination').text,
        sigle:
          annonce.search('sigle').text,
        forme_juridique:
          annonce.search('formeJuridique').text,
        date_commencement_activite:
          annonce.search('dateCommencementActivite').text,
        date_effet:
          annonce.search('dateEffet').text,
        descriptif:
          annonce.search('descriptif').text,
        denomination_pepm:
          annonce.search(
            'modificationsGenerales/precedentExploitantPM/denomination',
          ).text,
        siren_pepm:
          annonce.search(
            'modificationsGenerales/precedentExploitantPM/' \
            'numeroImmatriculation/numeroIdentification',
          ).text,
        nature_pepp:
          annonce.search(
            'modificationsGenerales/precedentExploitantPP/nature',
          ).text,
        nom_pepp:
          annonce.search(
            'modificationsGenerales/precedentExploitantPP/nom',
          ).text,
        prenom_pepp:
          annonce.search(
            'modificationsGenerales/precedentExploitantPP/prenom',
          ).text,
        nom_usage_pepp:
          annonce.search(
            'modificationsGenerales/precedentExploitantPP/nomUsage',
          ).text,
        siren_pepp:
          annonce.search(
            'modificationsGenerales/precedentExploitantPP/' \
            'numeroImmatriculation/numeroIdentification',
          ).text,
        nom_publication_ap:
          annonce.search('parutionAvisPrecedent/nomPublication').text,
        numero_parution_ap:
          annonce.search('parutionAvisPrecedent/numeroPublication').text,
        date_parution_ap:
          annonce.search('parutionAvisPrecedent/dateParution').text,
        numero_annonce_ap:
          annonce.search('parutionAvisPrecedent/numeroAnnonce').text,
        file:
          file.split('/').last,
        type_bodacc:
          'BODACC B',
        annee_parution:
          date,
      )
      return if type_annonce != 'rectificatif'
      rectify(annonce.search('parutionAvisPrecedent/numeroAnnonce').text,
              annonce.search('numeroIdentificationRCS').text)
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    # Rectify announcements
    def self.rectify(numero_annonce_ap, siren)
      to_delete = Modification.where(numero_annonce: numero_annonce_ap,
                                     type_annonce: 'annonce',
                                     siren: siren)
      return if to_delete.empty?
      to_delete.delete_all
      puts "Announcement #{numero_annonce_ap} has been deleted"
    end
  end
end
