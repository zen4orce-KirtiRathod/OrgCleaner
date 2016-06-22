public class VisualForcePageSelector {
    
    public static List<ApexPage> queryPage()
    {
        List<ApexPage> visualforcePages = [SELECT Name FROM ApexPage WHERE Name NOT IN ('CutsomObjectPage', 'CleanOrg')];
        return visualforcePages;
    }

}