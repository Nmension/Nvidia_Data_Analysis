import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt



def draw():
    #setup data

    #yearly revenue per activity data source
    df_yr = pd.read_csv('yearly_revenue_per_activity.csv', encoding='utf-16',index_col=0,parse_dates=True)
    #yearly data source
    df_y = pd.read_csv('yearly_data.csv', encoding='utf-16')
    #quarterly financials per activity source
    df_qrf =pd.read_csv('quarterly_revenue_per_activity.csv',encoding='utf-16')
    #quarterly data source
    df_qf = pd.read_csv('quarterly_financials.csv',encoding='utf-16')

    #quarterly financials operations
    df_bar2 = df_qrf.copy()
    df_bar2.reset_index(inplace=True)
    df_bar2 = df_bar2.pivot_table(index='name', columns=['year','quarter'], values='ammount', dropna=True, sort=False, observed=True).reindex(['Data Center','Gaming','Auto','ProViz','OEM & Other'],axis=0)
    #sums by cols for each activity
    df_sum1 = np.cumsum(a=df_bar2.loc[:, ([2019,2020,2021,2022,2023,2024,2025], [1])],axis=0)
    df_sum2 = np.cumsum(a=df_bar2.loc[:, ([2019,2020,2021,2022,2023,2024,2025], [2])],axis=0)
    df_sum3 = np.cumsum(a=df_bar2.loc[:, ([2019,2020,2021,2022,2023,2024,2025], [3])],axis=0)
    df_sum4 = np.cumsum(a=df_bar2.loc[:, ([2019,2020,2021,2022,2023,2024,2025], [4])],axis=0)

    #yearly data operations
    df_bar = df_yr.copy()
    df_bar.reset_index(inplace=True)
    df_bar['Years'] = [d.year for d in df_bar.year]
    df_bar = df_bar.pivot_table(index='Years', columns='name', values='ammount', dropna=True, sort=False, observed=True)

    #averages revenue/cost composition
    averages2023 = (np.average(df_y.loc[df_y['year'] <= 2023, ['net_income','cost_of_goods_sold', 'operating_expenses','taxes_and_interests']],axis=0) / np.average(df_y.loc[df_y['year'] <= 2023, ['revenue']],axis=0)).round(decimals=3) * 100
    averages2025 = (np.average(df_y.loc[df_y['year'] <= 2025, ['net_income','cost_of_goods_sold', 'operating_expenses','taxes_and_interests']],axis=0) / np.average(df_y.loc[df_y['year'] <= 2025, ['revenue']],axis=0)).round(decimals=3) * 100

    #valuations operations
    ins_a = np.average(df_y.loc[df_y['insiders'].notnull(), 'insiders'])
    inst_a = np.average(df_y.loc[df_y['institutions_top_3'].notnull(), 'institutions_top_3']) 
    rest_a = np.average(df_y.loc[df_y['rest'].notnull(), 'rest'])
    data=[ins_a,inst_a,rest_a]

    #variations operations
    res_ni=['----']
    res_ev=['----']
    res_mc=['----']
    res_rv=['----']
    for y1 in range(2019,2024,1):
        y2 = y1+1
        rv = ((df_y.loc[df_y['year'] == y2,'revenue'].values - df_y.loc[df_y['year'] == y1,'revenue'].values) / df_y.loc[df_y['year'] == y1,'revenue'].values  * 100)[0].round(1)
        ni = ((df_y.loc[df_y['year'] == y2,'net_income'].values - df_y.loc[df_y['year'] == y1,'net_income'].values) / df_y.loc[df_y['year'] == y1,'net_income'].values  * 100)[0].round(1)
        ev = ((df_y.loc[df_y['year'] == y2,'enterprise_value'].values - df_y.loc[df_y['year'] == y1,'enterprise_value'].values) / df_y.loc[df_y['year'] == y1,'enterprise_value'].values  * 100)[0].round(1)
        mc = ((df_y.loc[df_y['year'] == y2,'average_market_cap'].values - df_y.loc[df_y['year'] == y1,'average_market_cap'].values) / df_y.loc[df_y['year'] == y1,'average_market_cap'].values  * 100)[0].round(1)
        res_ni.append(f'{ni} %')
        res_rv.append(f'{rv} %')
        res_ev.append(f'{ev} %')
        res_mc.append(f'{mc} %')
        y1 += 1

    d1={'Revenue (YoY)': res_rv,'Net income (YoY)': res_ni, 'Enterprise value (YoY)': res_ev, 'Average market cap (YoY)': res_mc}
    tab1 = pd.DataFrame(data=d1,index=np.array(df_y.loc[df_y['year'] <= 2024, 'year']))

    res_oplev=['----']
    res_opin=['----']
    res_rev=['----']
    for y3 in range(2019,2025,1):
        y4 = y3+1
        opin = ((df_y.loc[df_y['year'] == y4,'operating_income'].values - df_y.loc[df_y['year'] == y3,'operating_income'].values) / df_y.loc[df_y['year'] == y3,'operating_income'].values  * 100)[0].round(1)
        rev = ((df_y.loc[df_y['year'] == y4,'revenue'].values - df_y.loc[df_y['year'] == y3,'revenue'].values) / df_y.loc[df_y['year'] == y3,'revenue'].values  * 100)[0].round(1)
        oplev = (opin/rev).round(1)
        if (opin < 0) & (rev < 0):
            res_oplev.append(f'-{oplev}')
        else:
            res_oplev.append(oplev)
        res_opin.append(f'{opin} %')
        res_rev.append(f'{rev} %')
        y3 += 1
        
    res_opm=[]
    for y in range(2019,2026,1):
        opm=((df_y.loc[df_y['year'] == y,'operating_income'].values) / df_y.loc[df_y['year'] == y,'revenue'].values  * 100)[0].round(1)
        res_opm.append(f'{opm} %')
        y += 1
    d2={'Operating Leverage Ratio': res_oplev, 'Operating Margin': res_opm, '% Δ Operating income (YoY)':res_opin, '% Δ Revenue (YoY)': res_rev }
    tab2 = pd.DataFrame(data=d2,index=np.array(df_y['year']))

    #data for macro part
    rev_c=[df_y.loc[df_y['year'] == 2024,'revenue'].values[0],53101,25785,62753,95567,53803]
    sum_r = np.sum([df_y.loc[df_y['year'] == 2025,'revenue'].values[0],53101,25785,62753,95567,53803])
    ms = np.round([df_y.loc[df_y['year'] == 2025,'revenue'].values[0] / sum_r * 100, 53101 / sum_r * 100, 25785 / sum_r * 100, 62753 / sum_r * 100, 95567 / sum_r * 100, 53803 / sum_r * 100],1)
    cagr= np.round([((((df_y.loc[df_y['year'] == 2025, 'revenue'].values / df_y.loc[df_y['year'] == 2023, 'revenue'].values) **(1/3)) - 1) * 100)[0],(((53101/63054)**(1/3))-1)*100,((25785/23601)**(1/3)-1)*100,((62753/60530)**(1/3)-1)*100,(((95567/102301)**(1/3))-1)*100,(((53803/51557)**(1/3))-1)*100],1)
    stock_p=[df_y.loc[df_y['year'] == 2024,'average_stock_price'].values[0],30.8345,157.6645,189.7064,115.6638,49.5486]
    outstanding_c=[df_y.loc[df_y['year'] == 2024, 'total_outstanding'].values[0],4280,1637,937,720,4062]
    mcc= np.multiply(stock_p, outstanding_c)
    pe_c= np.divide(mcc, rev_c).round(1)

    dmacro_ni = {'Nvidia': df_y['net_income'].values,'Intel': [21053,21048,20899,19868,8014,1689,-18756], 'AMD': [337,341,2490,3162,1320,854,1641], 'IBM': [8728,9431,5590,5743,1639,7502,6023], 'Dell': [-2181,4616,3250,5563,2442,3388,4592], 'CISCO': [110,11621,11214,10591,11812,12613,10320]}
    dmacro = {'Company':['Nvidia','Intel','AMD','IBM','Dell','CISCO'],'Market share (2025)': [f'{val} %' for val in ms], 'CAGR (2023-2025)': [f'{val} %' for val in cagr], 'P/S (2024)': pe_c}
    df_ni_comps = pd.DataFrame(data=dmacro_ni,index=df_y['year'])
    av = pd.DataFrame({"Competitors' avg":np.average(df_ni_comps[['Intel','AMD','IBM','Dell','CISCO']],axis=1)},index=df_y['year'])
    df_ni_comps = df_ni_comps.join(av)
    df_macro = pd.DataFrame(data=dmacro)

    ni_nvidia=['']
    ni_avg_compet=['']
    for y5 in range(2019,2025,1):
        y6 = y5+1
        ni_comparaison = ((df_y.loc[df_y['year'] == y6,'net_income'].values - df_y.loc[df_y['year'] == y5,'net_income'].values) / df_y.loc[df_y['year'] == y5,'net_income'].values  * 100)[0].round(1)
        ni_avg_comparaison = ((df_ni_comps.loc[df_ni_comps.index == y6,"Competitors' avg"].values - df_ni_comps.loc[df_ni_comps.index == y5,"Competitors' avg"].values) / df_ni_comps.loc[df_ni_comps.index == y5,"Competitors' avg"].values  * 100)[0].round(1)
        ni_nvidia.append(f'{ni_comparaison}%')
        ni_avg_compet.append(f'{ni_avg_comparaison}%')
        y5 += 1
    df_ni_comparaison = pd.DataFrame(data={'Nvidia YoY growth':ni_nvidia, "Competitors's YoY growth":ni_avg_compet},index=df_y['year'])

    #table 1 setup
    D2ER = np.array(df_y['total_debt'] / df_y['total_shareholders_equity']).round(3)
    d2e = { 'Debt-to-Equity Ratio': D2ER}
    df_d2e = pd.DataFrame(data=d2e,index=np.array(df_y['year']))
    

    #table 2 
    EBITDA = df_y['operating_income'].values + df_y['depreciation_and_amortization'].values
    ND_E = (df_y['net_debt'].values / EBITDA).round(4)
    d4 = { 'EBITDA': EBITDA, 'Net debt': np.array(df_y['net_debt']), 'Net Debt-to-EBITDA': ND_E}
    df_ebitda = pd.DataFrame(data=d4, index=np.array(df_y['year']))
    av_ndeb = np.average(df_ebitda['Net Debt-to-EBITDA']).round(3)
    
    def bar_line_dual_plot():
        #fig that shows how overall and segment-specific revenues evolved every year.
        fig, (ax1,ax2) = plt.subplots(nrows=1, ncols=2, figsize=(15,7))
        ax1.margins(x=0.05,y=0)
        #controls yticks limits
        start_y = 0  # Desired starting ytick val
        y = 140000
        #major/minor steps between yticks vals
        maj_steps= 15000
        min_steps= maj_steps / 2
        fig.suptitle("I. Nvidia's yearly revenue per activity (2019-2025)",size='large',weight='bold')
        color=['#e39e54','#4d7358','#d64d4d','#7bb3ff','#e2f4c7']
        df_bar.plot(kind='bar',xlabel='', ylabel='Revenue (in millions $)', color=color, edgecolor='black', ax=ax1)

        ax1.legend(title='Activity:', title_fontsize='large', fontsize='large', fancybox=True,edgecolor='grey')
        ax1.tick_params(axis='x', which='major', labelrotation=0)
        ax1.set_axisbelow(True)
        ax1.grid(which='major',axis='x', visible=False)
        ax1.grid(which='major',axis='y', aa=True,linewidth=1,visible=True)
        ax1.grid(which='minor',axis='y', aa=True,linewidth=0.3,visible=True)

        ax1.set_yticks(np.arange(start_y, y + 1, maj_steps))
        ax1.set_yticks(np.arange(start_y, y + 1, min_steps),labels=None,minor=True)
        ax1.set_ylim(bottom=start_y,top=y)
        ax1.spines[['top','right']].set_visible(False)
        ax1.tick_params(axis='y', right=False)
        ax1.tick_params(axis='y', which='minor', left=False, right=False)


        handler, labeler = ax2.get_legend_handles_labels()
        lab = ['Total revenue','Gaming','Data Center','ProViz','Auto','OEM & Other']
        sns.set_style('whitegrid')
        ax2.margins(x=0.05,y=0)
        ax2.plot(df_y['year'],df_y['revenue'], marker='o', markersize=4, color='black')
        ax2.plot(df_bar.index,df_bar['Gaming'], marker='o', markersize=4, color='#e39e54')
        ax2.plot(df_bar.index,df_bar['Data Center'], marker='o', markersize=4, color='#4d7358')
        ax2.plot(df_bar.index,df_bar['ProViz'], marker='o', markersize=4, color='#d64d4d')
        ax2.plot(df_bar.index,df_bar['Auto'], marker='o', markersize=4, color='#7bb3ff')
        ax2.plot(df_bar.index,df_bar['OEM & Other'], marker='o', markersize=4, color='#e2f4c7')
        ax2.legend(lab,fontsize='medium', fancybox=True, handleheight=1, handlelength=2, numpoints=2, edgecolor='grey')
        #fig2 above grid
        ax2.set_axisbelow(True)
        #grids to display
        ax2.grid(which='major',axis='y', aa=True, linewidth=1, visible=True)
        ax2.grid(which='minor',axis='y', aa=True, linewidth=0.3, visible=True)
        ax2.grid(which='major',axis='x', visible=False)

        #yticks to show and control
        ax2.set_yticks(np.arange(start_y, y + 1, maj_steps),labels='')
        ax2.set_yticks(np.arange(start_y, y + 1, min_steps),labels=None,minor=True)
        ax2.set_ylim(bottom=start_y, top=y)
        ax2.tick_params(axis='y', left=False, right=False)
        ax2.tick_params(axis='y', which='minor', left=False, right=False)

        ax2.spines[['top', 'right', 'left']].set_visible(False)
        
        # Save image and return fig 
        fig.savefig('bar_line_dual_plot.png', bbox_inches='tight', pad_inches=0.1)
        return fig
    bar_line_dual_plot()

    def stacked_bar_pie_dual_plot():
        N = 7 #numb of bar groups
        ind = np.arange(N) + 0.15 #the x locations for the groups
        width = 0.15 #width of the bars
        xtra_space = 0.05 #space between bars
        tot_space = width + xtra_space #width + xtra_space
        #min/max values for yticks & steps
        start_y = 0
        y_max = 40000
        maj_steps = 10000
        min_steps = maj_steps / 2
        #minor x ticks for quarters
        ind_m = []
        for i in range(N):
            pos_1 = ind[i] 
            pos_2 = ind[i] + tot_space 
            pos_3 = ind[i] + (tot_space*2)
            pos_4 = ind[i] + (tot_space*3)
            ind_m.extend([pos_1,pos_2,pos_3,pos_4])
            i += 1

        fig, (ax1,ax2) = plt.subplots(nrows=1,ncols=2,figsize=(16,7))
        #quarter1 for 7years
        #q1 = df_bar2.loc[:, ([2019,2020,2021,2022,2023,2024,2025], [1])]
        oem1 = tuple(df_sum1.loc['OEM & Other', ([2019,2020,2021,2022,2023,2024,2025], [1])].astype('int64') )
        auto1 = tuple(df_sum1.loc['Auto', ([2019,2020,2021,2022,2023,2024,2025], [1])].astype('int64') )
        data1 = tuple(df_sum1.loc['Data Center', ([2019,2020,2021,2022,2023,2024,2025], [1])].astype('int64') )
        proviz1 = tuple(df_sum1.loc['ProViz', ([2019,2020,2021,2022,2023,2024,2025], [1])].astype('int64') )
        gaming1 = tuple(df_sum1.loc['Gaming', ([2019,2020,2021,2022,2023,2024,2025], [1])].astype('int64') )

        rects4 = ax1.bar(ind, oem1, width, color='#e2f4c7', edgecolor='black') 
        rects3 = ax1.bar(ind, proviz1, width, color='#d64d4d', edgecolor='black') 
        rects2 = ax1.bar(ind, auto1, width, color='#7bb3ff', edgecolor='black')
        rects1 = ax1.bar(ind, gaming1, width, color='#e39e54', edgecolor='black')
        rects0 = ax1.bar(ind, data1, width, color='#4d7358', edgecolor='black') 
        
        #quarter2 for 7 years
        #q2 = df_bar2.loc[:, ([2019,2020,2021,2022,2023,2024,2025], [2])]
        oem2 = tuple(df_sum2.loc['OEM & Other', ([2019,2020,2021,2022,2023,2024,2025], [2])].astype('int64') )
        auto2 = tuple(df_sum2.loc['Auto', ([2019,2020,2021,2022,2023,2024,2025], [2])].astype('int64') )
        data2 = tuple(df_sum2.loc['Data Center', ([2019,2020,2021,2022,2023,2024,2025], [2])].astype('int64') )
        proviz2 = tuple(df_sum2.loc['ProViz', ([2019,2020,2021,2022,2023,2024,2025], [2])].astype('int64') )
        gaming2 = tuple(df_sum2.loc['Gaming', ([2019,2020,2021,2022,2023,2024,2025], [2])].astype('int64') )


        rects9 = ax1.bar(ind + tot_space, oem2, width, color='#e2f4c7', edgecolor='black')
        rects8 = ax1.bar(ind + tot_space, proviz2, width, color='#d64d4d', edgecolor='black') 
        rects7 = ax1.bar(ind + tot_space, auto2, width, color='#7bb3ff', edgecolor='black') 
        rects6 = ax1.bar(ind + tot_space, gaming2, width, color='#e39e54', edgecolor='black')
        rects5 = ax1.bar(ind + tot_space, data2, width, color='#4d7358', edgecolor='black') 
        
        #quarter3 for 7 years
        #q3 = df_bar2.loc[:, ([2019,2020,2021,2022,2023,2024,2025], [3])]
        oem3 = tuple(df_sum3.loc['OEM & Other', ([2019,2020,2021,2022,2023,2024,2025], [3])])
        auto3 = tuple(df_sum3.loc['Auto', ([2019,2020,2021,2022,2023,2024,2025], [3])])
        data3 = tuple(df_sum3.loc['Data Center', ([2019,2020,2021,2022,2023,2024,2025], [3])])
        proviz3 = tuple(df_sum3.loc['ProViz', ([2019,2020,2021,2022,2023,2024,2025], [3])])
        gaming3 = tuple(df_sum3.loc['Gaming', ([2019,2020,2021,2022,2023,2024,2025], [3])])

        rects14 = ax1.bar(ind + ((tot_space) * 2), oem3, width, color='#e2f4c7', edgecolor='black')
        rects13 = ax1.bar(ind + ((tot_space) * 2), proviz3, width, color='#d64d4d', edgecolor='black') 
        rects12 = ax1.bar(ind + ((tot_space) * 2), auto3, width, color='#7bb3ff', edgecolor='black') 
        rects11 = ax1.bar(ind + ((tot_space) * 2), gaming3, width, color='#e39e54', edgecolor='black')
        rects10 = ax1.bar(ind + ((tot_space) * 2), data3, width, color='#4d7358', edgecolor='black') 

        #quarter4 for 7 years
        #q4 = df_bar2.loc[:, ([2019,2020,2021,2022,2023,2024,2025], [4])]
        oem4 = tuple(df_sum4.loc['OEM & Other', ([2019,2020,2021,2022,2023,2024,2025], [4])])
        auto4 = tuple(df_sum4.loc['Auto', ([2019,2020,2021,2022,2023,2024,2025], [4])])
        data4 = tuple(df_sum4.loc['Data Center', ([2019,2020,2021,2022,2023,2024,2025], [4])])
        proviz4 = tuple(df_sum4.loc['ProViz', ([2019,2020,2021,2022,2023,2024,2025], [4])])
        gaming4 = tuple(df_sum4.loc['Gaming', ([2019,2020,2021,2022,2023,2024,2025], [4])])

        rects19 = ax1.bar(ind + ((tot_space) * 3), oem4, width, color='#e2f4c7', edgecolor='black')
        rects18 = ax1.bar(ind + ((tot_space) * 3), proviz4, width, color='#d64d4d', edgecolor='black') 
        rects17 = ax1.bar(ind + ((tot_space) * 3), auto4, width, color='#7bb3ff', edgecolor='black')
        rects16 = ax1.bar(ind + ((tot_space) * 3), gaming4, width, color='#e39e54', edgecolor='black')
        rects15 = ax1.bar(ind + ((tot_space) * 3), data4, width, color='#4d7358', edgecolor='black') 
        #zorder for the bars Vs grid
        ax1.set_axisbelow(True)
        #ylabels, title 
        ax1.set_title("II-a. Quarterly Revenue per activity segment (2019-2025)",pad=7, size='large', weight='bold')
        ax1.set_ylabel('Revenue (in millions $)')
        #position of maj xticks and xlabs
        ax1.set_xticks(ind+width+width)
        ax1.set_xticklabels( ('2019', '2020', '2021', '2022', '2023', '2024', '2025'))
        #use pad to place major xlabs bellow minor ones
        ax1.tick_params(axis='x', which='major', pad=15)
        #enable minor ticks and their position on the axis
        ax1.set_xticks(ind_m, minor=True)
        #minor xaxis labs
        ax1.set_xticklabels( ('1', '2', '3', '4','1', '2', '3', '4','1', '2', '3', '4','1', '2', '3', '4','1', '2', '3', '4','1', '2', '3', '4','1', '2', '3', '4'),minor=True)
        ax1.tick_params(right=False)
        #minor and major respective ticks & labels control
        ax1.set_yticks(np.arange(start_y, y_max + 1, maj_steps),labels=np.arange(start_y, y_max + 1, maj_steps))
        ax1.set_yticks(np.arange(start_y, y_max + 1, min_steps),labels=None,minor=True)
        #disable display of minor ticks on yaxis
        ax1.tick_params(axis='y',which='minor',left=False,right=False)
        #dual legend respecting the same color codes
        handler, labeler = ax1.get_legend_handles_labels()
        hd = [rects4, rects3, rects2, rects1, rects0]
        lab_ar = ['OEM & Other','ProViz','Auto','Gaming','Data Center']
        ax1.legend(hd, lab_ar, title='Activity:',title_fontsize='x-large',fontsize='x-large', fancybox=True, loc='lower right',bbox_to_anchor=(1.6,-0.03,0.5,0.9))
        #grid control setup
        ax1.grid(which='major',axis='y', aa=True,linewidth=1,visible=True)
        ax1.grid(which='minor',axis='y', aa=True,linewidth=0.3,visible=True)
        ax1.grid(which='major',axis='x', visible=False)
        ax1.grid(which='minor',axis='x', visible=False)
        #desable some spines
        ax1.spines[['top','right']].set_visible(False)
        ax1.set_position([0.45, 0.55, 0.5, 1]) # left, bottom, width, height

        data = df_bar.loc[2025]
        lab_a = ['Gaming','Data Center','ProViz','Auto','OEM & Other']
        act_colors=['#e39e54','#4d7358','#d64d4d','#7bb3ff','#e2f4c7']
        ax2.pie(data,autopct='%1.1f%%',explode=[0,0.05,0.35,0.25,0.05] ,radius=1,wedgeprops=dict(edgecolor='black',linewidth=0.4), colors=act_colors,textprops=dict(color="black",size=12,weight='bold'), pctdistance=0.58)
        #ax2.legend(lab_a,title='Activity:',title_fontsize='x-large',fontsize='large', fancybox=True, loc='lower right',bbox_to_anchor=(1.5,-0.11,1,1),handleheight=2,handlelength=4)
        ax2.set_title('II-b. Revenue by Activity Segment (2025)',y=1.19, weight='bold')
        ax2.set_position([1, 0.5, 0.35, 1])

        
        # Save image and return fig
        fig.savefig('stacked_bar_pie_dual_plot.png', bbox_inches='tight', pad_inches=0.1)
        return fig
    stacked_bar_pie_dual_plot()

    def incrusted_double_pie_plot():
        fig , ax = plt.subplots(nrows=1,ncols=1,figsize=(10,10),layout='constrained')
        size = 0.4
        #dif in colors for the 2 plots
        alpha=0.75
        #dual labels
        lab=['','','','','Net income', 'Cost of goods sold', 'Operating expenses', 'Taxes and interests']
        outer_colors = ['#6e7f80','#3E3F5B','#8AB2A6','#ACD3A8']
        inner_colors = [('#6e7f80',alpha),('#3E3F5B',alpha),('#8AB2A6',alpha),('#ACD3A8',alpha)]
        #inner pie
        ax.pie(averages2023,autopct='%1.1f%%', radius=1-size,wedgeprops=dict(width=size,edgecolor='black'),colors=inner_colors,textprops=dict(color="w",size=11, weight='bold'))
        #outer pie
        ax.pie(averages2025,autopct='%1.1f%%', radius=1,wedgeprops=dict(width=size,edgecolor='black'),pctdistance=0.8,textprops=dict(color="w",size=14, weight='bold'), colors=outer_colors)
        #dual legend
        ax.legend(lab,title='  2019-23                 2024-25',title_fontsize='small',fontsize='medium', fancybox=True, loc='lower left',bbox_to_anchor=(1, 0.1, 0.5, 1),handleheight=2,handlelength=4,ncols=2,alignment='left')
        plt.title('III. Evolution of the average revenue structure\n\n (between: 2019-2023 & 2024-2025)',weight='bold')

        # Save image and return fig
        fig.savefig('incrusted_double_pie_plot.png', bbox_inches='tight', pad_inches=0.1)
        return fig
    incrusted_double_pie_plot()

    def line_pie_dual_plot():
        #pie chart for the overall shareholders' distribution through 5 years => need a line chart/bar for the evolution thorugh the same years to show overall public financial strategy and health
        ins_a = np.average(df_y.loc[df_y['insiders'].notnull(), 'insiders'])
        inst_a = np.average(df_y.loc[df_y['institutions_top_3'].notnull(), 'institutions_top_3']) 
        rest_a = np.average(df_y.loc[df_y['rest'].notnull(), 'rest'])
        data_v=[ins_a,inst_a,rest_a]
        #minor/major control yticks labels  
        miny = 0
        ym = 23500
        maj_steps = 4000
        min_steps= maj_steps / 4
        fig = plt.figure(figsize=(15,7))
        lab_v=['Insiders','Top 3 institutions', 'Rest: outsiders and institutions']
        sns.set_style('whitegrid')

        plt.subplot(1,2,1).spines[['top','right']].set_visible(False)
        plt.margins(x=0.05,y=0) #fig 1 start margin from axis
        #data selection
        plt.plot(df_y['year'],df_y['insiders'],color='#ff6f69',linewidth=2.5)
        plt.plot(df_y['year'],df_y['institutions_top_3'],color='#ffcc5c',linewidth=2.5)
        plt.plot(df_y['year'],df_y['rest'],color='#88d8b0',linewidth=2.5)
        plt.title("IV-a. Shareholders' groups (2019-2024)",y=1.02,weight='bold')
        #grid display control
        plt.grid(visible=True, which='major', axis='y',linewidth=1)
        plt.grid(visible=True, which='minor', axis='y',linewidth=0.3)
        plt.grid(which='major',axis='x', visible=False)
        #minor/major yticks control
        plt.yticks(np.arange(miny, ym + 1, maj_steps),labels=np.arange(miny, ym + 1, maj_steps))
        plt.yticks(np.arange(miny, ym + 1, min_steps),labels=None,minor=True)
        plt.tick_params(axis='y',which='minor',left=False,right=False)
        plt.tick_params(axis='both',left=True,bottom=True,top=False)
        #ylab
        plt.ylabel('Number of shares (in millions)')

        plt.subplot(1,2,2)
        #fig2
        plt.pie(data_v,autopct='%1.1f%%', colors=['#ff6f69','#ffcc5c','#88d8b0'],textprops=dict(color="w",size=16, weight='bold'))
        plt.title("IV-b. Average proportion of shareholders' groups (2019-2024)",y=1.03,weight='bold')
        plt.legend(lab_v,title_fontsize='large',fontsize='medium', fancybox=True, loc='lower right',bbox_to_anchor=(1.5,-0.05),handleheight=2,handlelength=4,edgecolor='grey')

        # Save image and return fig
        fig.savefig('line_pie_dual_plot.png', bbox_inches='tight', pad_inches=0.1)
        return fig
    line_pie_dual_plot()

    def incrusted_dual_bar_plus_line_plot():
        fig, ax1 = plt.subplots(nrows=1,ncols=1, figsize=(15,7))
        ax1.margins(x=0.05,y=0)
        start_y = 0  #min y-tick value
        y=79000 #max y
        #bar pos control
        index = df_ni_comps.index
        w = 0.34
        ofs = w / 2
        #first/main fig
        recA = ax1.bar(index - ofs, df_ni_comps["Nvidia"],width = w, color='#76b900',edgecolor=None)
        recB = ax1.bar(index + ofs, df_ni_comps["Competitors' avg"], width = w, color='#00b3da',edgecolor=None)
        plt.ylabel("Net income (in millions $)")
        #pct text for nvidia
        itt = 0
        for p in recA:
            wid = p.get_width()
            h = p.get_height()
            x_t, y_t = p.get_xy()
            if h <= 3000:
                plt.text(x_t+wid/2, y_t+h*0.30, str(df_ni_comparaison.iloc[itt,0]), ha='center', weight='bold', fontsize='small',color='white')
            else:
                plt.text(x_t+wid/2, y_t+h*0.45, str(df_ni_comparaison.iloc[itt,0]), ha='center', weight='bold', fontsize='small',color='white')
            itt += 1
        #pct text for avg comp
        itt2 = 0
        for p2 in recB:
            wid2 = p2.get_width()
            h2 = p2.get_height()
            x_t2, y_t2 = p2.get_xy()
            if h2 <= 2000:
                plt.text(x_t2 + wid2 / 2, y_t2 + h2 *2, str(df_ni_comparaison.iloc[itt2,1]), ha='center', weight='bold', fontsize='small',color='black')
            else:
                plt.text(x_t2 + wid2 / 2, y_t2 + h2 *0.45, str(df_ni_comparaison.iloc[itt2,1]), ha='center', weight='bold', fontsize='small',color='black')
            itt2 += 1
        
        #second overlayed fig
        ax2 = ax1.twinx()
        ax2.plot(df_ni_comps.index - ofs,df_ni_comps['Nvidia'],marker='o', color='#598c00',mec='black',mfc='black',ms=3.2,mew=0.45)
        ax2.plot(df_ni_comps.index + ofs,df_ni_comps["Competitors' avg"], marker='o', color='#00487d',mec='black',mfc='black',ms=3.2,mew=0.45)
        #set grid bellow fig
        ax1.set_axisbelow(True)
        #first fig grid display
        ax1.grid(visible=True, which='major',axis='y',linewidth=1)
        ax1.grid(visible=True,which='minor',axis='y',linewidth=0.3)
        ax1.grid(visible=False, which='major',axis='x')
        #second fig grid display
        ax2.grid(visible=False, which='major',axis='both')
        ax2.grid(visible=False, which='minor',axis='both')
        #first fig ticks setup (which to show or not, where they start, etc)
        ax1.set_yticks(np.arange(start_y, y + 1, 10000),labels=np.arange(start_y, y + 1, 10000))
        ax1.set_yticks(np.arange(start_y, y + 1, 5000),labels=None,minor=True)
        ax1.tick_params(axis='y',which='minor',left=False,right=False)
        ax1.set_ylim(bottom=start_y,top=y,auto=False)
        #second fig ticks setup
        ax2.set_yticks(np.arange(start_y, y + 1, 10000),labels=None)
        ax2.set_ylim(ymin=start_y,top=y,auto=False)
        ax2.tick_params(right=False)
        ax2.margins(x=0.05,y=0)
        #plot spines inverted control
        ax2.spines[['top', 'right', 'left']].set_visible(False)
        ax1.spines[['top', 'right']].set_visible(False)
        #main title
        plt.suptitle("V. Nvidia & competitors: Net income YoY (2019-2025)", weight='bold')
        #legend setup
        handler, labeler = ax1.get_legend_handles_labels()
        hd = [recA,recB]
        lab=['Nvidia',"Competitors' avg"]
        plt.legend(hd, lab,title_fontsize='large',fontsize='x-large',fancybox=True)

        # Save image and return fig
        fig.savefig('incrusted_dual_bar_plus_line_plot.png', bbox_inches='tight', pad_inches=0.1)
        return fig
    incrusted_dual_bar_plus_line_plot()