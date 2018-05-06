package com.elderstudios.service;

import com.elderstudios.domain.GuestBookEntry;
import com.elderstudios.domain.GuestBookEntryRepository;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by tony on 29/06/17.
 */

@Service
public class GuestBookService {

    @Autowired
    private GuestBookEntryRepository guestBookEntryRepository;

    public List <GuestBookEntry> findAllEntries() {
        List <GuestBookEntry> entries = this.guestBookEntryRepository.findAll ();

        for (GuestBookEntry e: entries) {
            if (StringUtils.containsAny (e.getComment (), "<>")) {
                e.setComment ("Redacted - HTML Content?");
            }
        }

        return entries;
    }

    public void save (GuestBookEntry newEntry) {
        this.guestBookEntryRepository.save (newEntry);
    }

    public void delete (Integer id) {
        this.guestBookEntryRepository.delete (id);
    }

    public GuestBookEntry findOne (Integer id) {
        return this.guestBookEntryRepository.findOne (id);
    }

}
