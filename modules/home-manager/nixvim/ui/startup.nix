{
  programs.nixvim = {
    plugins.startup = {
      enable = true;

      colors = {
        background = "#ffffff";
        foldedSection = "#ffffff";
      };

      sections = {
        header = {
          type = "text";
          oldfilesDirectory = false;
          align = "center";
          foldSection = false;
          title = "Header";
          margin = 5;
          content = [
            "_____/\\\\\\\\\_____________________________________________________________________________/\\\_________________"
            "____/\\\\\\\\\\\\\__________________________________________________________________________\/\\\________________"
            "____/\\\/////////\\\_______________________________________________________________/\\\______\/\\\_______________"
            "____\/\\\_______\/\\\__/\\\\\\\\\\\__/\\\\\\\\\_____/\\/\\\\\\\___/\\\\\\\\\_____/\\\\\\\\\\\_\/\\\______________"
            "_____\/\\\\\\\\\\\\\\\_\///////\\\/__\////////\\\___\/\\\/////\\\_\////////\\\___\////\\\////__\/\\\\\\\\\\______"
            "______\/\\\/////////\\\______/\\\/______/\\\\\\\\\\__\/\\\___\///____/\\\\\\\\\\_____\/\\\______\/\\\/////\\\____"
            "_______\/\\\_______\/\\\____/\\\/_______/\\\/////\\\__\/\\\__________/\\\/////\\\_____\/\\\_/\\__\/\\\___\/\\\___"
            "________\/\\\_______\/\\\__/\\\\\\\\\\\_\//\\\\\\\\/\\_\/\\\_________\//\\\\\\\\/\\____\//\\\\\___\/\\\___\/\\\__"
            "_________\///________\///__\///////////___\////////\//__\///___________\////////\//______\/////____\///____\///__"
          ];
          highlight = "Statement";
          defaultColor = "";
          oldfilesAmount = 0;
        };

        body = {
          type = "mapping";
          oldfilesDirectory = false;
          align = "center";
          foldSection = false;
          title = "Menu";
          margin = 5;
          content = [
            [
              " Find File"
              "Telescope find_files"
              "ff"
            ]
            [
              "󰍉 Find Word"
              "Telescope live_grep"
              "fr"
            ]
            [
              " Recent Files"
              "Telescope oldfiles"
              "fg"
            ]
            [
              " File Browser"
              "Telescope file_browser"
              "fe"
            ]
            [
              " Copilot Chat"
              "CopilotChat"
              "ct"
            ]
            [
              "󰧑 SecondBrain"
              "edit ~/projects/personal/SecondBrain"
              "sb"
            ]
          ];
          highlight = "string";
          defaultColor = "";
          oldfilesAmount = 0;
        };
      };

      options = {
        paddings = [1 3];
      };

      parts = [
        "header"
        "body"
      ];
    };
  };
}
