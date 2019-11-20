package org.bits.wilp;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

public class CountryList {
    private List<Country> countries;
    private Map<Integer, Country> countryMap = new HashMap<>();
    private Map<String, List<Country>> countriesByContinent;
    private Random random = new Random();

    private List<String> continents = Arrays.asList("asia", "europe", "africa", "oceania", "north america", "south america");
    private boolean initialized;

    public CountryList() {
    }

    public void init(URL fileUrl) {
        try {
            List<String> countriesString = Files.readAllLines(Paths.get(fileUrl.toURI()));
            countries = countriesString.stream().map(s -> {
                String[] splits = s.split(",");
                if (splits.length == 2)
                    return new Country(splits[0], splits[1], "NONE");
                return new Country(splits[0], splits[1], splits[2]);
            }).collect(Collectors.toList());
            countries.forEach(c -> countryMap.put(c.getId(), c));
            countriesByContinent =  countries.stream().collect(Collectors.groupingBy(c -> c.getContinent().toLowerCase()));
            initialized = true;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    public boolean isInitialized() {
        return initialized;
    }

    public Country countryById(int id) {
        return countryMap.get(id);
    }

    public Country nextCountry() {
        int nextIndex = random.nextInt(countries.size() - 1);
        return countries.get(nextIndex);
    }

    public List<Country> nextBatch(String continent) {
        continent = sanitize(continent);
        List<Country> selectedCountries = countries;
        if (continent != null && !"world".equals(continent)) {
            selectedCountries = countriesByContinent.get(continent);
        }
        int indices[] = new int[4];
        indices[0] = nextInt(selectedCountries.size() - 1, new int[0]);
        indices[1] = nextInt(selectedCountries.size() - 1, indices[0]);
        indices[2] = nextInt(selectedCountries.size() - 1, indices[0], indices[1]);
        indices[3] = nextInt(selectedCountries.size() - 1, indices[0], indices[1], indices[2]);
        return Arrays.asList(selectedCountries.get(indices[0]), selectedCountries.get(indices[1]),
                selectedCountries.get(indices[2]), selectedCountries.get(indices[3]));
    }

    private String sanitize(String continent) {
        continent = continent.replace("_", " ");
        if (continents.contains(continent.toLowerCase()))
            return continent.toLowerCase();
        return "world";
    }

    private int nextInt(int bound, int... notIn) {
        int nextIndex = random.nextInt(bound);
        while(contains(nextIndex, notIn)) {
            nextIndex = random.nextInt(bound);
        }
        return nextIndex;
    }

    private boolean contains(int toBeSearched, int... in) {
        return Arrays.stream(in).anyMatch(i -> i == toBeSearched);
    }

    public static void main(String[] args) throws URISyntaxException, IOException {
        CountryList countryList = new CountryList();
        Country c1 = countryList.nextCountry();
        Country c2 = countryList.nextCountry();
        Country c3 = countryList.nextCountry();
        Country c4 = countryList.nextCountry();
        System.out.println(c1);
        System.out.println(c2);
        System.out.println(c3);
        System.out.println(c4);
    }
}
