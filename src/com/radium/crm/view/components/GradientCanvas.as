package com.radium.crm.view.components
{
	
    import mx.containers.Canvas;
    import mx.styles.StyleManager;
    import mx.utils.ColorUtil;

	/**
	 * Canvas with a gradient background.
	 */
	
    public class GradientCanvas extends Canvas
    {
    	
        override protected function updateDisplayList( w:Number, h:Number ):void
        {
            super.updateDisplayList( w, h ) ;

            var fillColors:Array = getStyle( "fillColors" ) ; 
            var fillAlphas:Array = getStyle( "fillAlphas" ) ; 
            var cornerRadius:Number = getStyle( "cornerRadius" ) ; 
            
            StyleManager.getColorNames( fillColors ) ;

            graphics.clear( ) ;

            drawRoundRect( 0, 0, w, h, cornerRadius, fillColors,
            	           fillAlphas, verticalGradientMatrix( 0, 0, w, h ) ) ;
        }
    }
}