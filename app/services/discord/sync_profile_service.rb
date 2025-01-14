module Discord
  class SyncProfileService
    def initialize(user)
      @user = user
    end

    def execute
      return unless @user.discord_user_id.present? && configuration.configured?

      role_ids =
        [
          @user.cohorts.pluck(:discord_role_ids),
          configuration.default_role_ids
        ].flatten - [nil]

      return if role_ids.empty?

      Discordrb::API::Server.update_member(
        "Bot #{configuration.bot_token}",
        configuration.server_id,
        @user.discord_user_id,
        roles: role_ids,
        nick: @user.name
      )
    rescue Discordrb::Errors::UnknownMember
      Rails.logger.error "Unknown member #{@user.discord_user_id}"
      @user.update!(discord_user_id: nil)
    rescue Discordrb::Errors::NoPermission
      Rails
        .logger.error "No permission to update member #{@user.discord_user_id}"
    rescue RestClient::BadRequest
      Rails
        .logger.error "Bad request with discord_user_id: #{@user.discord_user_id}"
    end

    def configuration
      @configuration ||= Schools::Configuration::Discord.new(@user.school)
    end
  end
end
