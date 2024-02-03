package ensemble;

import ensemble.control.Popover;
import ensemble.control.PopoverTreeList;
import javafx.scene.Node;

public class SamplePopoverTreeList extends PopoverTreeList implements Popover.Page {


    public SamplePopoverTreeList() {

    }

    @Override
    public void setPopover(Popover popover) {

    }

    @Override
    public Popover getPopover() {
        return null;
    }

    @Override
    public Node getPageNode() {
        return this;
    }

    @Override
    public String getPageTitle() {
        return "Samples";
    }

    @Override
    public String leftButtonText() {
        return "< Back";
    }

    @Override
    public void hanldeLeftButton() {

    }

    @Override
    public String rightButtonText() {
        return "Done";
    }

    @Override
    public void handleRightButton() {

    }

    @Override
    public void handleShown() {

    }

    @Override
    public void handleHidden() {

    }

    @Override
    public Object call(Object param) {
        return null;
    }
}
