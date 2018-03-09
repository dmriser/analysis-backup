import json
import argparse
import ROOT 
import numpy as np 
import time 
import multiprocessing 
import string, random  
from multiproc import MultiProc 

def get_histogram_dict(config, title):
    histos = {}

    histos['x'] = []
    
    for index in range(len(config['bins']['x'])-1):
        histos['x'].append(ROOT.TH1F('x_'+str(index)+'_'+title,'',100,-180,180))

    return histos

def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))

def event_filter(config, event):
    if event.meson_id == config['cut_values']['meson_id']:
        if np.sqrt(event.mm2) > config['cut_values']['missing_mass'][0]:
            if np.sqrt(event.mm2) < config['cut_values']['missing_mass'][1]:
                if np.sqrt(event.tof_mass2) > config['cut_values']['tof_mass'][0]:
                    if np.sqrt(event.tof_mass2) < config['cut_values']['tof_mass'][1]:
                        return True
    return False 

def process_file(config, event_filter, input_file):

    data = ROOT.TChain('miniTree')
    data.AddFile(input_file.split()[0])

    histos = get_histogram_dict(config, id_generator(size=4))

    for event in data: 
        if event_filter(config, event):
            histos['x'][0].Fill(event.phi_h)

    return histos 

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('config')
    return parser.parse_args()

def main():
    args = get_args()

    with open(args.config) as json_file:
        config = json.load(json_file)
        

        file_list = open(config['system']['file_list']).readlines()
        
        if config['system']['n_files'] < len(file_list):
            file_list = file_list[:config['system']['n_files']]
        
        t_start = time.time()
            
        # n_cores, function, data
        mp = MultiProc(config['system']['n_cores'], 
                       lambda x: process_file(config, event_filter, x), 
                       file_list) 
        output = mp.run()
    
        print ('Program finished after time = %f') % (time.time()-t_start)

        histos = get_histogram_dict(config, 'merged')
        
        for out in output:
            for index, hist in enumerate(out['x']):
                histos['x'][index].Add(hist)


        output_file = ROOT.TFile(config['system']['output']+config['system']['config_name']+'.root','recreate')
        output_file.cd()
        
        for key, value in histos.iteritems():
            for hist in histos[key]:
                hist.Write()

        output_file.Close()

if __name__ == '__main__':
    main()
