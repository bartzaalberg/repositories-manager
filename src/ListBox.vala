using Granite.Widgets;

namespace RepositoriesManager {
public class ListBox : Gtk.ListBox{

    private ConfigFileReader configFileReader = new ConfigFileReader ();
    private StackManager stackManager = StackManager.get_instance();

    public void empty(){
        this.foreach ((ListBoxRow) => {
            this.remove(ListBoxRow);
        }); 
    }

    public void getRepositories(string searchWord = ""){
        this.empty();

        stackManager.getStack().visible_child_name = "list-view";

        var repositories = configFileReader.getRepositories();

        if(searchWordDoesntMatchAnyInList(searchWord, repositories)) {
            stackManager.getStack().visible_child_name = "not-found-view";
            return;
        }

        foreach (string repository in repositories) {
            if(searchWord == ""){
                this.add (new ListBoxRow (repository));
                continue;
            }

            if(searchWord in repository){             
                this.add (new ListBoxRow (repository));
            }
        }

        this.show_all();
    }

    private bool searchWordDoesntMatchAnyInList(string searchWord, string[] repositories){
        int matchCount = 0;
        
        if(searchWord == ""){
            return false;
        }

        foreach (string repository in repositories) {
            if(searchWord in repository){
                matchCount++;                
            }
        }
        return matchCount == 0;    
    }
}
}
