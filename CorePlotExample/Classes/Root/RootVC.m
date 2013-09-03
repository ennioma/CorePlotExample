//
//  RootVC.m
//  Camelot Forecasting Tool
//
//  Created by Ennio Masi on 9/3/13.
//  Copyright (c) 2013 em. All rights reserved.
//

#import "RootVC.h"
#import <QuartzCore/QuartzCore.h>

@interface RootVC ()

@end

@implementation RootVC {
    CPTGraphHostingView *scatterPlotView;
    CPTXYGraph *graph;
    NSMutableArray *dataForChart, *dataForPlot;
    
    UILabel *title;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self basicViewCustomizations];

    scatterPlotView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(20.0f, 50.0f, self.view.bounds.size.width - 40.0f, self.view.bounds.size.height - 100.0f)];
    [self.view addSubview:scatterPlotView];

    [self buildScatterPlot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    scatterPlotView.frame = CGRectMake(20.0f, 50.0f, self.view.bounds.size.width - 40.0f, self.view.bounds.size.height - 100.0f);
    title.frame = CGRectMake(20.0f, 10.0f, self.view.bounds.size.width - 40.0f, 30.0f);
}

- (void) basicViewCustomizations {
    title = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 10.0f, self.view.bounds.size.width - 40.0f, 30.0f)];
    [title setText:@"Core Plot example"];
    [title setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:title];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void) buildScatterPlot {
    [self buildAndAddGraphToScatterPlotView];
    [self managePlotSpace];
    [self buildAxes];
    [self addLinesWithSymbols];
    [self buildSomeRandomData];
}

- (void) buildAndAddGraphToScatterPlotView {
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero	];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    scatterPlotView.hostedGraph = graph;
    
    graph.paddingLeft   = 20.0;
    graph.paddingTop    = 20.0;
    graph.paddingRight  = 20.0;
    graph.paddingBottom = 50.0;
    graph.plotAreaFrame.borderLineStyle = nil;
}

- (void) managePlotSpace {
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10.0f) length:CPTDecimalFromFloat(20.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10.0f) length:CPTDecimalFromFloat(60.0f)];
    CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-30.0f)
                                                              length:CPTDecimalFromFloat(50.0f)];
    CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10.0f)
                                                              length:CPTDecimalFromFloat(60.0f)];
    plotSpace.globalXRange = globalXRange;
    plotSpace.globalYRange = globalYRange;
}

- (void) buildAxes {
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromString(@"2.0");
    x.minorTickLength = 5.0f;
    x.majorTickLength = 7.0f;
    x.minorTicksPerInterval = 1;
    x.title = @"X title";
    x.labelOffset = 3.0f;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromString(@"10");
    y.minorTicksPerInterval = 1;
    y.minorTickLength = 5.0f;
    y.majorTickLength = 7.0f;
    y.title = @"Y title";
    y.labelOffset = 3.0f;
}

- (void) addLinesWithSymbols {
    CPTScatterPlot *scatterPlot = [[CPTScatterPlot alloc] init];
    scatterPlot.identifier = @"DataPlot";
    
    CPTMutableLineStyle *lineStyle = [scatterPlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 2.0f;
    lineStyle.lineColor = [CPTColor orangeColor];
    scatterPlot.dataLineStyle = lineStyle;
    scatterPlot.dataSource = self;
    
    scatterPlot.opacity = 0.0f;
    scatterPlot.cachePrecision = CPTPlotCachePrecisionDecimal;
    [graph addPlot:scatterPlot];

    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = 2.0f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode = kCAFillModeForwards;
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    [scatterPlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];

    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol pentagonPlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(6.0, 6.0);
    scatterPlot.plotSymbol = plotSymbol;
}

- (void) buildSomeRandomData {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(-10, 20)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(-8, 7)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(-6, 2)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(-4, 24)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(-2, 18)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(0, 3)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(2, 35)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(4, 8)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(6, 36)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(8, 20)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(10, 40)]];
    
    dataForPlot = data;
}

#pragma mark -
#pragma mark Plot Data Source Methods
- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot {
    return [dataForPlot count];
}

- (NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSValue *value = [dataForPlot objectAtIndex:index];
    CGPoint point = [value CGPointValue];
    
    if (fieldEnum == CPTScatterPlotFieldX)
        return [NSNumber numberWithFloat:point.x];
    else 
        return [NSNumber numberWithFloat:point.y];
}

- (CPTLayer *) dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    static CPTMutableTextStyle *whiteText = nil;
    
    if (!whiteText) {
        whiteText = [[CPTMutableTextStyle alloc] init];
        whiteText.color = [CPTColor whiteColor];
    }
    
    CPTTextLayer *newLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%lu", (unsigned long)index] style:whiteText];
    
    return newLayer;
}

@end